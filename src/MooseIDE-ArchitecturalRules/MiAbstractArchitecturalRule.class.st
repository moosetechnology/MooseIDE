"
I am the root of the Renraku rules checking the MooseIDE architectural rules for browsers and models.

Purpose: share the definitions used by all these rules.
- a browser is any class named Mi*Browser in a MooseIDE-* package
- a model is any class named Mi*Model in a MooseIDE-* package
- the model of MiXyzBrowser is MiXyzModel (#modelNameFor:)

Collaborators: MiAbstractBrowser and MiAbstractModel (the roots browsers and models must inherit from); Renraku calls #basicCheck: on each class.

Invariants: my subclasses check classes only (class-side #checksClass), never metaclasses, and belong to the architectural group.

Main API: #isBrowser:, #isModel:, #modelNameFor:; subclasses implement #basicCheck:, and class-side #ruleName, #rationale, #uniqueIdentifierName.
"
Class {
	#name : 'MiAbstractArchitecturalRule',
	#superclass : 'ReAbstractRule',
	#category : 'MooseIDE-ArchitecturalRules',
	#package : 'MooseIDE-ArchitecturalRules'
}

{ #category : 'testing - interest' }
MiAbstractArchitecturalRule class >> checksClass [
	^ true
]

{ #category : 'accessing' }
MiAbstractArchitecturalRule class >> groupSelector [
	^ #architecturalGroup
]

{ #category : 'testing' }
MiAbstractArchitecturalRule class >> isAbstract [
	^ self == MiAbstractArchitecturalRule
]

{ #category : 'testing' }
MiAbstractArchitecturalRule >> isBrowser: aClass [
	"A browser is any class named Mi*Browser in a MooseIDE-* package"

	^ (self isMooseIDEClass: aClass) and: [
		  (aClass name beginsWith: 'Mi') and: [ aClass name endsWith: 'Browser' ] ]
]

{ #category : 'testing' }
MiAbstractArchitecturalRule >> isModel: aClass [
	"A model is any class named Mi*Model in a MooseIDE-* package"

	^ (self isMooseIDEClass: aClass) and: [
		  (aClass name beginsWith: 'Mi') and: [ aClass name endsWith: 'Model' ] ]
]

{ #category : 'testing' }
MiAbstractArchitecturalRule >> isMooseIDEClass: aClass [
	"Only instance-side classes of MooseIDE-* packages are subject to the MooseIDE rules"

	^ aClass isMeta not and: [ aClass package name beginsWith: 'MooseIDE-' ]
]

{ #category : 'accessing' }
MiAbstractArchitecturalRule >> modelNameFor: aBrowserClass [
	"By convention, the model of MiXyzBrowser is MiXyzModel"

	^ ((aBrowserClass name allButLast: 'Browser' size) , 'Model') asSymbol
]
