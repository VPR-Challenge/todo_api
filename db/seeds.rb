user = User.create!(name: "Test User", email: "test@example.com", password: "password")

columns = ['Pendente', 'Fazendo', 'Feito'].map do |title|
  Column.create!(title: title, user: user)
end

10.times do |i|
  Task.create!(title: "Tarefa #{i}", description: "Descrição da tarefa #{i}", due_date: Date.today + i.days, user: user, column: columns.sample)
end
