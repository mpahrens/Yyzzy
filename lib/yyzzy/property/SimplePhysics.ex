defmodule Yyzzy.Property.SimplePhysics do
  defmodule Velocity2D do
    use Yyzzy.Property
    defstruct x: 0, y: 0
  end
  defmodule Velocity3D do
    use Yyzzy.Property
    defstruct x: 0, y: 0, z: 0
  end
  defmodule Acceleration3D do
    use Yyzzy.Property
    defstruct x: 0, y: 0, z: 0
  end
  defmodule Acceleration2D do
    use Yyzzy.Property
    defstruct x: 0, y: 0, z: 0
  end
  defmodule BodyRect do
    use Yyzzy.Property
    defstruct height: 0, width: 0
  end
  defmodule BodyPoly do
    use Yyzzy.Property
    defstruct points: []
  end
end
