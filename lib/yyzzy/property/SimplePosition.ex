defmodule Yyzzy.Property.SimplePosition do
  defmodule Point2D do
    use Yyzzy.Property
    defstruct x: 0, y: 0
  end
  defmodule Point3D do
    use Yyzzy.Property
    defstruct x: 0, y: 0, z: 0
  end
end
