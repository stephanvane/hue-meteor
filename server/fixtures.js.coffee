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
  Timer.insert
    name: 'timer1'
    schedule: later.parse.text('at 20:00')
