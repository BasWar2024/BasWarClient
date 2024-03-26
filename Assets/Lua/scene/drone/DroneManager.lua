DroneManager = class("DroneManager")

function DroneManager:ctor()
    self.droneTable = {}
end

function DroneManager:loadDrone(building)
    local drone = ggclass.Drone.new(building)

    return drone
end


return DroneManager