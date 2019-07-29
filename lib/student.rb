class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
  new_student = Student.new

  new_student.id = row[0]
  new_student.name = row[1]
  new_student.grade = row[2]
  new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    rows = DB[:conn].execute(sql)
    rows.map do |row| 
      Student.new_from_db(row)
    end
  end 

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    self.all.find do |student|
      student.name == name
    end 
  end 
    
  def self.all_students_in_grade_9
    self.all.select do |student|
      student.grade == '9'
    end 
  end

  def self.students_below_12th_grade
    self.all.select do |student|
      student.grade.to_i < 12
  end 
end 

  def self.first_X_students_in_grade_10(num)
    student_objects = self.all.select do |student|
      student.grade == "10"
    end
    x_array = []
    student_objects[0...num].each do |student|
      x_array << student
    end
    x_array
  end
    
  def self.first_student_in_grade_10
    grade_ten = self.all.select do |student|
      student.grade == '10'
    end
    grade_ten.first
  end

  def self.all_students_in_grade_X(num)
    self.all.select do |student|
      student.grade.to_i == num
    end
  end	  

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
