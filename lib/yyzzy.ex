defmodule Yyzzy do
  defstruct uid: nil, properties: %{}, metadata: %{}, entities: %{}

  ##
  # Higher Order Functions

  ##
  # Mapping and restructuring

  @doc """
    applies the function to every entity in the tree yyzzy and then
    rebuilds the structure
  """
  def map_into(yyzzy, fun), do: Enum.map(yyzzy, fun) |> Enum.into(yyzzy)
  @doc """
    applies the function to every entity in the tree yyzzy
    iff the entities has the property key specified by
    opts = [properties: [Property1, Property2]]
    or leaves the entity alone otherwise and then rebuilds the structure.
    if opts are supplied, then it behaves like map_into
  """
  def map_over_into(yyzzy, fun, property: property), do: map_over_into(yyzzy, fun, properties: [property])
  def map_over_into(yyzzy, fun, kind: kind), do: map_over_into(yyzzy, fun, kinds: [kind])
  def map_over_into(yyzzy, fun, properties: props) do
    f = fn y ->
      keys = props -- Map.keys(y.properties)
      case keys do
        [] -> fun.(y)
        _ -> y
      end
    end
    map_over_into(yyzzy, f, [])
  end
  def map_over_into(yyzzy, fun, kinds: kinds) do
    f = fn y ->
          if(contains_keys?(kinds,Map.keys(y.properties))) do
            fun.(y)
          else
            y
          end
        end
    map_over_into(yyzzy,f,[])
  end
  def map_over_into(yyzzy,fun,[]), do: map_into(yyzzy, fun)
  defp contains_keys?([], _), do: false
  defp contains_keys?(kinds,keys) do
    [kind | tail] = kinds
    if (Enum.reduce(keys, false, fn x, acc ->
      case kind -- Module.split(x) do
        [] -> true or acc
        _ -> false or acc
      end
    end)) do
      true
    else
      contains_keys?(tail, keys)
    end
  end

  ##
  # Merging and Reduction
  @doc """
  iterate, BFS, over two Yyzzy objects that have the same root uid
  add the children
  """
  def merge(yyzzy1 = %Yyzzy{entities: e1}, yyzzy2 = %Yyzzy{entities: e2}, policy \\ Yyzzy.Policy.overwrite) do
    case policy.(yyzzy1, yyzzy2) do
      {:halt, y} -> y
      y ->
      entities = Enum.reduce(e2,e1, fn {key,y}, acc ->
        case Map.get(acc,key) do
          nil -> Map.put(acc, key, y)
          x   -> Map.put(acc, key, merge(x,y,policy))
        end
      end)
      %Yyzzy{y | entities: entities}
    end
  end

  ##
  # Entity Tree Builders
  # for all public facing functions, the child entities are plain-ol'
  # %Yyzzy{}s. The private helpers take care of marshalling to back end
  # representation. Also! heirarchical uid structure to be enforced.
  @doc """
    make a lambda yyzzy abstraction in the form the :lambda
    type child entities expects. the three args:
    getfn/0 - returns the %Yyzzy{} child
    upfn/1  - takes a fn : %Yyzzy{} -> %Yyzzy and returns :ok
    type    - :lambda by default, but can be a custom type if
              you are specifying your own put, get, and get_and_update
  """
  def make_lambda(getfn, upfn, deletefn, type \\ :lambda) do
    fn :get                  -> getfn.()
       :info                 -> type
       {:update, f}          -> upfn.(f)
       :delete               -> deletefn.()
     end
  end
  @doc """
    puts the child entity in yz's entities map using strategy type
    if yz already has a child, key calls update instead.
    opts:
      force: true | false -> if force -> always puts new child entity in
                                         overwriting any prexisting one.

    Put takes linear time in the length of the child tree because it
    reassigns the uid to match the new tree structure.
  """
  def put(yz, key, child, type \\ :struct, opts \\ [force: false]) do
    if get_info(yz, key) in [:undefined, :struct] or opts[:force]
    do
      case type do
        :genserver -> _put_genserver(yz, key, child)
        :node      -> _put_node(yz, key, child)
        _          -> _put(yz, key, child) # struct or lambda case
      end
    else
      update(yz, key, fn _ -> child end)
    end
  end
  def _put(yz, key, child) do
    entities = Map.put(yz.entities, key, child)
    yz = %Yyzzy{yz | entities: entities}
    _clean_child_uid(yz, key)
  end
  defp _clean_child_uid(yz, key) do
    uid = yz.uid
    case get(yz, key).uid do
      {^uid, ^key} -> yz
      _ -> update(yz, key, fn x ->
        y = %Yyzzy{x | uid: {uid, key}}
        Enum.reduce(Map.keys(y.entities),y, fn key, y_acc ->
          _clean_child_uid(y_acc, key)
        end)
      end)
    end
  end
  def _put_genserver(yz, key, child) do
    #make a genserver to handle
    {:ok, pid} = GenServer.start_link(Yyzzy.Entity.GenServer, child)
    getfn = fn -> GenServer.call(pid, :get) end
    upfn  = fn f -> GenServer.cast(pid, {:update, f}) end
    deletefn =  fn -> GenServer.stop(pid, :shutdown) end
    lambda = make_lambda(getfn, upfn, deletefn, {:genserver, pid})
    _put(yz, key, lambda)
  end
  @doc """
  TODO
  """
  def _put_node(yz,key,child) do
    :undefined
  end
  def get_info(yz, key) do
    case yz.entities[key] do
      f when is_function(f) -> f.(:info)
      nil -> :undefined
      _ -> :struct
    end
  end
  def get(yz, key, default \\ %Yyzzy{}) do
    case yz.entities[key] do
      f when is_function(f) -> f.(:get)
      nil -> default
      e -> e
    end
  end
  @doc """
  updates the child entity assigned to key in the parent yz
  using upfn which takes a Yyzzy and returns a modified Yyzzy
  """
  def update(yz, key, upfn) do
    case yz.entities[key] do
      f when is_function(f) ->
        f.({:update,upfn})
        yz
      nil -> yz
      e -> _put(yz, key, upfn.(e))
    end
  end
  @timeout 30_000 #30 seconds
  @doc """
  takes a yz, a key of the child entity to update,
  an upfn that maps a Yyzzy -> Yyzzy and a default value
  incase the yz does not contain that child key.
  returns the tuple {updated_yz,updated_child}
  where the updated_yz respected any lambda abstractions
  but the child is a Yyzzy data structure at the time of update.
  """
  def get_and_update(yz, key, upfn, default \\ %Yyzzy{}) do
    up_fn_send = fn x ->
      upfn.(x)
      send self, {:updated, key}
    end
    case yz.entities[key] do
      f when is_function(f) ->
        f.({:update, up_fn_send})
        receive do
          {:updated, ^key} -> {yz, get(yz, key, default)}
        after
          @timeout ->
            updated = upfn.(default)
            {_put(yz, key, updated),updated}
        end
      nil ->
        updated = upfn.(default)
        {_put(yz, key, updated),updated}
      e ->
        updated = upfn.(e)
        {_put(yz, key, updated), updated}
    end
  end
  @doc """
  flattens a yz by grabbing all of its entities from their respective
  locations and then calling get_all on them. essentially taking a snapshot
  of the game state of an Yyzzy entitity at the time.
  """
  def get_all(yz) do
    entities = for {k,v} <- yz.entities, into: %{} do
      child = case v do
        f when is_function(f) -> f.(:get)
        e -> e
      end
      {k, get_all(child)}
    end
    %Yyzzy{yz | entities: entities}
  end
  @doc """
  Returns the root entity, yz, after removing key from its children,
  calling the necessary delete function for that child if applicable.
  """
  def delete(yz, key) do
    case yz.entities[key] do
      f when is_function(f) ->
        f.(:delete)
      _ -> :ok
    end
    %Yyzzy{yz | entities: Map.delete(yz.entities, key)}
  end
  @doc """
    Given a root Yyzzy and the heirarchical form of a uid,
    traverse the tree and return that node
  """
  def find(yz,key), do: find(yz,key,%Yyzzy{})
  def find(yz = %Yyzzy{uid: uid}, key, _default) when uid == key, do: yz
  def find(yz, key, default) do
    keylist = _ser_uid(key,:list)
    _find(yz, keylist, default)
  end
  defp _find(_,  []   , default), do: default
  defp _find(yz, [key], default), do: get(yz,key,default)
  defp _find(yz, [head | tail], default) do
    case (yz.uid) do
      ^head -> _find(yz,tail,default)
      {_, ^head} -> _find(yz,tail,default)
      _     -> _find(get(yz,head,yz),tail,default)

    end
  end
  @doc """
  Given a yz, a key in heirarchical form, and a function that maps an Yyzzy -> Yyzzy
  searchs over the yz, and recursively applies updates to matching children
  and returns the original yz modified.
  """
  def find_and_update(yz, key, upfn) do
    keylist = _ser_uid(key, :list)
    _find_and_update(yz,keylist,upfn)
  end
  def _find_and_update(yz,[],_), do: yz
  def _find_and_update({_parents,myid},list,upfn),
    do: _find_and_update(myid,list,upfn)
  def _find_and_update(yz,[key],upfn), do: update(yz,key,upfn)
  def _find_and_update(yz, [head | tail], upfn) do
    case (yz.uid) do
      ^head -> _find_and_update(yz, tail, upfn)
      _     -> update(yz, head, fn x ->
                 _find_and_update(x,tail,upfn)
               end)
    end
  end
  @doc """
  Pops the head off of the yyzzy tree (root node) and promotes the
  child mapped to by key to root, if it exists. returns yz otherwise.
  Does not alter uids.
  """
  def retree(yz, key) do
    new_root = Yyzzy.get(yz, key, yz)
    entities = Map.delete(yz.entities, key)
    %Yyzzy{new_root | entities: Map.merge(new_root.entities, entities)}
  end
  @doc """
    Given a Yyzzy entity, will pretty print the nested uid format either as a string
    with the given opt: delimiter: "<delimiter>" where <delimiter> could be something
    like ";" or "." or ":"
    or opt: delimiter: :list, where it will make a list of the uids with the root
    uid being the head.
  """
  def serialize_uid(%Yyzzy{uid: uid}, [delimiter: dem] \\ [delimiter: ";"]), do: _ser_uid(uid, dem)
  defp _ser_uid({parent, child}, :list), do: _ser_uid(parent, :list) ++ [child]
  defp _ser_uid({parent,child}, dem), do: _ser_uid(parent,dem) <> dem <> to_string(child)
  defp _ser_uid(root, :list), do: [root]
  defp _ser_uid(root, _dem), do: to_string(root)
end
