class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    creation = Student.new
    creation.id = row[0]
    creation.name = row[1]
    creation.grade = row[2]
    return creation
  end

  def self.all
    all = DB[:conn].execute("Select * FROM students")
    all.map do |row|
      self.new_from_db(row)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)

    self.all.find do |student|
      student.name == name
    end
    # find the student in the database given a name
    # return a new instance of the Student class
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

  def self.all_students_in_grade_9
     sql = <<-SQL
     SELECT * 
     FROM students
     WHERE grade = 9
     SQL
     all = DB[:conn].execute(sql)
    all.map do |row|
      # a = Student.new
      # a.id = row[0]
      # a.name =row[1]
      # a.grade = row[2]
      Student.new_from_db(row)
    end

  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12
    SQL
    DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    convert_array_to_students( DB[:conn].execute(sql,limit) )
  end

  def self.convert_array_to_students(array)
      array.map do |row|
        Student.new_from_db(row)
      end
  end

  def self.first_student_in_grade_10
    first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL
    table = DB[:conn].execute(sql,x)
  end
end
