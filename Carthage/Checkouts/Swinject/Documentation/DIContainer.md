# DI Container

Dependency Injection (DI) Container manages dependencies of your system. First you register the way how the dependencies or actual types should be resolved. Then you use the DI container to get instances whose dependencies or actual types are resolved by the DI container. In Swinject, `Container` class represents the DI container.

In the field of Dependency Injection or Inversion of Control, different terms are used or terms are used differently. Swinject uses the following terms.

* **Service**: Protocol defining an interface for a dependent type.
* **Component**: Actual type implementing a service.
* **Factory**: Function or closure instantiating a component type.

## Registration to DI Container

A service resolved to a component is registered with `register` method of a component that takes the service type and a factory of the component. If the component depends on another service, `resolve` method can be used in the factory to inject the dependency. The actual type of the dependency will be resolved later when the component instance is created.

Here is an example of the registration.

    let container = Container()
    container.register(AnimalType.self) { _ in Cat(name: "Mimi") }
    container.register(PersonType.self) { r in
        PetOwner(name: "Stephen", pet: r.resolve(AnimalType.self)!)
    }

Where the protocols and classes are:

    protocol AnimalType {
        var name: String { get }
    }
    protocol PersonType {
        var name: String { get }
    }

    class Cat: AnimalType {
        let name: String

        init(name: String) {
            self.name = name
        }
    }

    class PetOwner: PersonType {
        let name: String
        let pet: AnimalType

        init(name: String, pet: AnimalType) {
            self.name = name
            self.pet = pet
        }
    }

After you register the dependencies, you can get service instances from the container by calling `resolve` method. It returns resolved components as the specified service (protocol) types.

    let animal = container.resolve(AnimalType.self)!
    let person = container.resolve(PersonType.self)!
    let pet = (person as! PetOwner).pet

    print(animal.name) // prints "Mimi"
    print(animal is Cat) // prints "true"
    print(person.name) // prints "Stephen"
    print(person is PetOwner) // prints "true"
    print(pet.name) // prints "Mimi"
    print(pet is Cat) // prints "true"

Here the instances resolved by `resolve` method are unwrapped with `!` because it returns nil if no registration for the specified service type is found.

## Named Registration to DI Container

If you would like to register two or more components for a service type, you can name the registrations to differentiate.

    let container = Container()
    container.register(AnimalType.self, name: "cat") { _ in Cat(name: "Mimi") }
    container.register(AnimalType.self, name: "dog") { _ in Dog(name: "Hachi") }

Then you can get the service instances with the registered names.

    let cat = container.resolve(AnimalType.self, name:"cat")!
    let dog = container.resolve(AnimalType.self, name:"dog")!

    print(cat.name) // prints "Mimi"
    print(cat is Cat) // prints "true"
    print(dog.name) // prints "Hachi"
    print(dog is Dog) // prints "true"

Where `Dog` class is:

    class Dog: AnimalType {
        let name: String

        init(name: String) {
            self.name = name
        }
    }

## Registration with Arguments to DI Container

A factory closure to register a service can take arguments that are passed when the service is resolved. When you register the service, the arguments can be specified after the `Resolvable` parameter (in the following example, it is unused as `_`).

    container.register(AnimalType.self) { _, name in
        Horse(name: name)
    }
    container.register(AnimalType.self) { _, name, running in
        Horse(name: name, running: running)
    }

Then pass runtime arguments when you call `resolve` method. If you pass only 1 argument, use `resolve(_:argument:)`.

    let animal1 = container.resolve(AnimalType.self, argument: "Spirit")!

    print(animal1.name) // prints "Spirit"
    print((animal1 as! Horse).running) // prints "false"

If you pass 2 arguments or more, use `resolve(_:arguments:)` where the arguments are passed as a tuple.

    let animal2 = container.resolve(AnimalType.self, arguments: ("Lucky", true))!

    print(animal2.name) // prints "Lucky"
    print((animal2 as! Horse).running) // prints "true"

Where the `Horse` class is:

    class Horse: AnimalType {
        let name: String
        let running: Bool

        convenience init(name: String) {
            self.init(name: name, running: false)
        }

        init(name: String, running: Bool) {
            self.name = name
            self.running = running
        }
    }

## Registration Keys

A registration is stored in a container with an internally created key. The container tries to resolve a service that is registered with the key.

The key consists of:

* Type of the service
* Name of the registration
* Number and types of the arguments

If a registration matches an existing registration with all the parts of the key, the existing registration is overwritten with the new registration.

For example the following registrations can co-exist in a container because the service types are different.

    container.register(AnimalType.self) { _ in Cat(name: "Mimi") }
    container.register(PersonType.self) { r in
        PetOwner(name: "Stephen", pet: r.resolve(AnimalType.self)!)
    }

The following registrations can co-exist in a container because the registration names are different.

    container.register(AnimalType.self, name: "cat") { _ in Cat(name: "Mimi") }
    container.register(AnimalType.self, name: "dog") { _ in Dog(name: "Hachi") }

The following registrations can co-exist in a container because the numbers of arguments are different. The first registration has no arguments, and the second has an argument.

    container.register(AnimalType.self) { _ in Cat(name: "Mimi") }
    container.register(AnimalType.self) { _, name in Cat(name: name) }

The following registrations can co-exist in a container because the types of arguments are different. The first registration has `String` and `Bool` types. The second registration has `Bool` and `String` types in the order.

    container.register(AnimalType.self) { _, name, running in
        Horse(name: name, running: running)
    }
    container.register(AnimalType.self) { _, running, name in
        Horse(name: name, running: running)
    }

_[Next page: Injection Patterns](InjectionPatterns.md)_

_[Table of Contents](README.md)_
