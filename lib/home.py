class Person:
    def __init__(self, name):
        self.name = name
        self.age = None
    
    def set_age(self, age):
        self.age = age
        return self

    def greet(self):
        return f"Hello, my name is {self.name} and I am {self.age} years old."

person = Person("Alice").set_age(30)
print(person.greet())  # Output: Hello, my name is Alice and I am 30 years old.