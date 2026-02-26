"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `children` | `FamixCBContext` | `parent` | `FamixCBTRuleComponent` | Every child context or condition of this context.|
| `entities` | `FamixCBContext` | `contexts` | `MooseObject` | Every entity that is a part of the context.|
| `parent` | `FamixCBTRuleComponent` | `children` | `FamixCBContext` | Parent context, if it exists.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `contextFilter` | `Object` | nil | Filter applied on entities. It can be a block or a custom object|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `summary` | `String` | nil | A rule component can have an explanatory summary|

"
Class {
	#name : 'FamixCBContext',
	#superclass : 'FamixCBEntity',
	#traits : 'FamixCBTRuleComponent',
	#classTraits : 'FamixCBTRuleComponent classTrait',
	#instVars : [
		'#children => FMMany type: #FamixCBTRuleComponent opposite: #parent',
		'#contextFilter => FMProperty'
	],
	#category : 'Famix-CriticBrowser-Entities-Entities',
	#package : 'Famix-CriticBrowser-Entities',
	#tag : 'Entities'
}

{ #category : 'meta' }
FamixCBContext class >> annotation [

	<FMClass: #Context super: #FamixCBEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : 'instance creation' }
FamixCBContext class >> named: aString on: anObject [

	^ self new
		  name: aString;
		  contextFilter: anObject;
		  yourself
]

{ #category : 'instance creation' }
FamixCBContext class >> named: aString on: anObject summary: aSummary [

	^ self new
		  name: aString;
		  contextFilter: anObject;
		  summary: aSummary;
		  yourself
]

{ #category : 'adding' }
FamixCBContext >> addChild: aRuleComponent [
	aRuleComponent parent: self
]

{ #category : 'adding' }
FamixCBContext >> addChildren: anObject [
	<generated>
	^ self children add: anObject
]

{ #category : 'adding' }
FamixCBContext >> addEntity: anObject [
	<generated>
	^ self entities add: anObject
]

{ #category : 'accessing' }
FamixCBContext >> children [
	"Relation named: #children type: #FamixCBTRuleComponent opposite: #parent"

	<generated>
	<FMComment: 'Every child context or condition of this context.'>
	<derived>
	^ children
]

{ #category : 'accessing' }
FamixCBContext >> children: anObject [

	<generated>
	children value: anObject
]

{ #category : 'accessing' }
FamixCBContext >> contextBlock [

	self
		deprecated: 'Please use #contextFilter instead'
		transformWith:
		'`@receiver contextBlock' -> '`@receiver contextFilter'.
	^ self contextFilter
]

{ #category : 'accessing' }
FamixCBContext >> contextBlock: anObject [

	self
		deprecated: 'Please use #contextFilter: instead'
		transformWith:
		'`@receiver contextBlock: `@arg'
		-> '`@receiver contextFilter: `@arg'.

	self contextFilter: anObject
]

{ #category : 'accessing' }
FamixCBContext >> contextFilter [

	<FMProperty: #contextFilter type: #Object>
	<generated>
	<FMComment: 'Filter applied on entities. It can be a block or a custom object'>
	^ contextFilter
]

{ #category : 'accessing' }
FamixCBContext >> contextFilter: anObject [

	anObject asCBContextFilterIn: self
]

{ #category : 'accessing' }
FamixCBContext >> contextFilterBlock: aBlock [

	contextFilter := aBlock
]

{ #category : 'accessing' }
FamixCBContext >> contextFilterString: aString [

	contextFilter := Smalltalk compiler evaluate: aString
]

{ #category : 'accessing' }
FamixCBContext >> customContextFilter: anObject [

	contextFilter := anObject
]

{ #category : 'accessing' }
FamixCBContext >> entities [
	"Relation named: #entities type: #MooseObject opposite: #contexts"

	<generated>
	<FMComment: 'Every entity that is a part of the context.'>
	<derived>
	<FMProperty: #entities type: #MooseObject opposite: #contexts>
	^ self attributeAt: #entities ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #contexts ]
]

{ #category : 'accessing' }
FamixCBContext >> entities: anObject [

	<generated>
	self entities value: anObject
]

{ #category : 'testing' }
FamixCBContext >> isCBContext [

	^ true
]

{ #category : 'printing' }
FamixCBContext >> printAsBlock [

	^ contextFilter asString
]

{ #category : 'as yet unclassified' }
FamixCBContext >> putViolationsInto: aDictionary [
	children do: [ :child | child putViolationsInto: aDictionary ]

]

{ #category : 'removing' }
FamixCBContext >> removeChild: aRuleComponent [

	(children includes: aRuleComponent) ifFalse: [ ^ self ].
	children remove: aRuleComponent.
	aRuleComponent setParentToNilIfNeeded.
	aRuleComponent resetExecutionOfTree
]

{ #category : 'removing' }
FamixCBContext >> resetExecutionOfTree [
	self entities removeAll.
	children do: [ :child | child resetExecutionOfTree ]

]

{ #category : 'running' }
FamixCBContext >> runDownTree: aCollection withCallback: aBlock [

	self entities ifEmpty: [ 
		self runOn: aCollection withCallback: aBlock ].
	children do: [ :child | 
		child runDownTree: self entities asMooseGroup withCallback: aBlock ]
]

{ #category : 'running' }
FamixCBContext >> runOn: aCollection [

	self entities: (contextFilter value: aCollection)
]

{ #category : 'running' }
FamixCBContext >> runOn: aCollection withCallback: aBlock [

	aBlock cull: self name.
	self entities: (contextFilter value: aCollection)
]

{ #category : 'as yet unclassified' }
FamixCBContext >> runUpTree: aCollection [

	self entities ifEmpty: [ self runOn: (parent runUpTree: aCollection) ].
	^ self entities
]

{ #category : 'ston persistence' }
FamixCBContext >> stonOn: stonWriter [

	stonWriter writeObject: self streamMap: [ :dictionary |
			self class stonAllInstVarNames do: [ :each |
					(self instVarNamed: each) ifNotNil: [ :value |
							dictionary at: each asSymbol put: (value isClosure
									 ifTrue: [ value asString ]
									 ifFalse: [ value ]) ] ] ]
]

{ #category : 'running' }
FamixCBContext >> tagRuleResult [

	| model |

	model := children ifNotEmpty: [
		         (children first violations collect: #violatingEntity) first
			         mooseModel ].
	children do: [ :c | c tagRuleResultInModel: model ]
]
