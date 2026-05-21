"
Custom rule to detect or refute dead methods.

It must be configured with:
- a regular expression on the fully-qualified name  to detect matching entities
- a boolean indicating whether it asserts or refutes that the entities are dead
"
Class {
	#name : 'MiDeadOnNameCustomRule',
	#superclass : 'MiDeadAbstractCustomRule',
	#instVars : [
		'ruleIdentifier',
		'nameRegex',
		'compiledRegex',
		'refuteDead'
	],
	#category : 'MooseIDE-DeadCode-Rules',
	#package : 'MooseIDE-DeadCode',
	#tag : 'Rules'
}

{ #category : 'settings management' }
MiDeadOnNameCustomRule >> currentConfiguration [

	^ MiDeadCustomNameSettingsConfiguration new
		ruleIdentifier: ruleIdentifier ;
		nameRegex: nameRegex ;
		refuteDead: refuteDead ;
		yourself
]

{ #category : 'settings management' }
MiDeadOnNameCustomRule >> defaultConfiguration [

	^MiDeadCustomNameSettingsConfiguration new
		ruleIdentifier: self defaultRuleIdentifier ;
		nameRegex: self defaultNameRegex ;
		refuteDead: self defaultRefuteDead;
		yourself
]

{ #category : 'settings management' }
MiDeadOnNameCustomRule >> defaultNameRegex [

	^'package\.class\.method.*'
]

{ #category : 'settings management' }
MiDeadOnNameCustomRule >> defaultRefuteDead [

	^false
]

{ #category : 'settings management' }
MiDeadOnNameCustomRule >> defaultRuleIdentifier [

	^'unknown'
]

{ #category : 'initialization' }
MiDeadOnNameCustomRule >> initialize [ 

	super initialize.

	ruleIdentifier := self defaultRuleIdentifier.
	nameRegex := self defaultNameRegex.
	refuteDead := self defaultRefuteDead.
]

{ #category : 'as yet unclassified' }
MiDeadOnNameCustomRule >> isDead: anEntity [

	^refuteDead
		ifTrue: [ (self nameMatchexRegex: anEntity) not ]
		ifFalse: [ self nameMatchexRegex: anEntity ]
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> name [

	^super name , ruleIdentifier 
]

{ #category : 'as yet unclassified' }
MiDeadOnNameCustomRule >> nameMatchexRegex: anEntity [

	^compiledRegex matches: anEntity mooseName
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> nameRegex [

	^ nameRegex
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> nameRegex: anObject [

	nameRegex := anObject.
	compiledRegex := nameRegex asRegex 
]

{ #category : 'as yet unclassified' }
MiDeadOnNameCustomRule >> notDead: anEntity [

	^refuteDead
		ifTrue: [ self nameMatchexRegex: anEntity ]
		ifFalse: [ (self nameMatchexRegex: anEntity) not ]
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> refuteDead [

	^refuteDead 
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> refuteDead: anObject [

	refuteDead := anObject
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> ruleIdentifier [

	^ ruleIdentifier
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> ruleIdentifier: anObject [

	ruleIdentifier := anObject
]

{ #category : 'settings management' }
MiDeadOnNameCustomRule >> settingsPresenterExtent [

	^ 400 @ 250
]

{ #category : 'accessing' }
MiDeadOnNameCustomRule >> toolName [
	"polymorphism with MiAbstractModel for opening settings"

	^self name
]

{ #category : 'settings management' }
MiDeadOnNameCustomRule >> updateFromConfiguration: aConfiguration [

	self ruleIdentifier: aConfiguration ruleIdentifier.
	self nameRegex: aConfiguration nameRegex.
	self refuteDead: aConfiguration refuteDead.

]
