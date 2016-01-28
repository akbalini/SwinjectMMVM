//
//  AssemblerSpec.swift
//  Swinject
//
//  Created by mike.owens on 12/9/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Swinject

class AssemblerSpec: QuickSpec {
    override func spec() {
        
        describe("Assembler basic init") {
            it("can assembly a single container") {
                let assembler = try! Assembler(assemblies: [
                    AnimalAssembly()
                ])
                let cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
                
                let sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).to(beNil())
            }
            
            it("can assembly a multiple container") {
                let assembler = try! Assembler(assemblies: [
                    AnimalAssembly(),
                    FoodAssembly()
                ])
                let cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
                
                let sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).toNot(beNil())
                expect(sushi is Sushi) == true
            }
            
            it("can assembly a multiple container with inter dependencies") {
                let assembler = try! Assembler(assemblies: [
                    AnimalAssembly(),
                    FoodAssembly(),
                    PersonAssembly()
                ])
                let petOwner = assembler.resolver.resolve(PetOwner.self)
                expect(petOwner).toNot(beNil())
                
                let cat = petOwner!.pet
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
                
                let sushi = petOwner!.favoriteFood
                expect(sushi).toNot(beNil())
                expect(sushi is Sushi) == true
            }
            
            it("can assembly a multiple container with inter dependencies in any order") {
                let assembler = try! Assembler(assemblies: [
                    PersonAssembly(),
                    AnimalAssembly(),
                    FoodAssembly(),
                ])
                let petOwner = assembler.resolver.resolve(PetOwner.self)
                expect(petOwner).toNot(beNil())
                
                let cat = petOwner!.pet
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
                
                let sushi = petOwner!.favoriteFood
                expect(sushi).toNot(beNil())
                expect(sushi is Sushi) == true
            }
        }
        
        describe("Assembler lazy build") {
            it("can assembly a single container") {
                let assembler = try! Assembler(assemblies: [])
                var cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).to(beNil())
                
                assembler.applyAssembly(AnimalAssembly())
                
                cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
            }
            
            it("can assembly a single load aware container") {
                let assembler = try! Assembler(assemblies: [])
                var cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).to(beNil())
                
                let loadAwareAssembly = LoadAwareAssembly() { resolver in
                    let cat = resolver.resolve(AnimalType.self)
                    expect(cat).toNot(beNil())
                    expect(cat!.name) == "Bojangles"
                }
                
                expect(loadAwareAssembly.loaded) == false
                assembler.applyAssembly(loadAwareAssembly)
                expect(loadAwareAssembly.loaded) == true
                
                cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Bojangles"
            }
            
            it("can assembly a multiple containers 1 by 1") {
                let assembler = try! Assembler(assemblies: [])
                var cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).to(beNil())
                
                var sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).to(beNil())
                
                assembler.applyAssembly(AnimalAssembly())
                
                cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
                
                sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).to(beNil())
                
                assembler.applyAssembly(FoodAssembly())
                
                sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).toNot(beNil())
            }
            
            it("can assembly a multiple containers at once") {
                let assembler = try! Assembler(assemblies: [])
                var cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).to(beNil())
                
                var sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).to(beNil())
                
                assembler.applyAssemblies([
                    AnimalAssembly(),
                    FoodAssembly()
                ])
                
                cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
                
                sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).toNot(beNil())
            }
        }
        
        describe("Assembler load aware") {
            it("can assembly a single container") {
                let loadAwareAssembly = LoadAwareAssembly() { resolver in
                    let cat = resolver.resolve(AnimalType.self)
                    expect(cat).toNot(beNil())
                    expect(cat!.name) == "Bojangles"
                }
                
                expect(loadAwareAssembly.loaded) == false
                let assembler = try! Assembler(assemblies: [
                    loadAwareAssembly
                ])
                expect(loadAwareAssembly.loaded) == true

                let cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Bojangles"
            }
            
            it("can assembly a multiple container") {
                let loadAwareAssembly = LoadAwareAssembly() { resolver in
                    let cat = resolver.resolve(AnimalType.self)
                    expect(cat).toNot(beNil())
                    expect(cat!.name) == "Bojangles"
                    
                    let sushi = resolver.resolve(FoodType.self)
                    expect(sushi).toNot(beNil())
                }
                
                expect(loadAwareAssembly.loaded) == false
                let assembler = try! Assembler(assemblies: [
                    loadAwareAssembly,
                    FoodAssembly()
                ])
                expect(loadAwareAssembly.loaded) == true
                
                let cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Bojangles"
                
                let sushi = assembler.resolver.resolve(FoodType.self)
                expect(sushi).toNot(beNil())
            }
        }
        
        describe("Assembler with properties") {
            it("can assembly with properties") {
                let assembler = try! Assembler(assemblies: [
                    PropertyAsssembly()
                ], propertyLoaders: [
                    PlistPropertyLoader(bundle: NSBundle(forClass: self.dynamicType.self), name: "first")
                ])
                
                let cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "first"
            }
            
            it("can't assembly with missing properties") {
                expect {
                    try Assembler(assemblies: [
                        PropertyAsssembly()
                    ], propertyLoaders: [
                        PlistPropertyLoader(bundle: NSBundle(forClass: self.dynamicType.self), name: "noexist")
                    ])
                }.to(throwError(errorType: PropertyLoaderError.self))
            }
        }
        
        describe("Empty Assembler") {
            it("can create an empty assembler and build it") {
                let assembler = Assembler()
                
                var cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).to(beNil())
                
                assembler.applyAssembly(AnimalAssembly())
                
                cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "Whiskers"
                
                let loader = PlistPropertyLoader(bundle: NSBundle(forClass: self.dynamicType.self), name: "first")
                try! assembler.applyPropertyLoader(loader)
                
                assembler.applyAssembly(PropertyAsssembly())
                
                cat = assembler.resolver.resolve(AnimalType.self)
                expect(cat).toNot(beNil())
                expect(cat!.name) == "first"
            }
        }
    }
}
