if Light.find().count() == 0
  Light.insert
    name: 'Woonkamer bank'
    id: '1'
  Light.insert
    name: 'Woonkamer tv',
    id: '2'
  Light.insert
    name: 'Keuken',
    id: '3'
  Light.insert
    name: 'Badkamer',
    id: '4'
  Light.insert
    name: 'Slaapkamer',
    id: '5'

if Timer.find().count() == 0
  lights = Light.find({}, limit: 3).map((l) -> l._id)
  data = hue: 0, on:true

  Timer.insert
    name: 'timer1'
    lights: lights
    schedule: 'at 20:00'
    data: data
