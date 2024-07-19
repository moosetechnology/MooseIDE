"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `ruleContainer` | `FamixCBTRuleComponent` | `ruleComponents` | `FamixCBTRuleComposite` | Parent context, if it exists.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `ruleComponents` | `FamixCBTRuleComposite` | `ruleContainer` | `FamixCBTRuleComponent` | Every child context or condition of this context.|

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `entities` | `FamixCBContext` | `contexts` | `MooseObject` | Every entity that is a part of the context.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `contextBlock` | `Object` | nil | Block to execute to get the context's entities|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `summary` | `String` | nil | A rule component can have an explanatory summary|

"
Class {
	#name : #FamixCBContext,
	#superclass : #FamixCBEntity,
	#traits : 'FamixCBTRuleComponent + FamixCBTRuleComposite',
	#classTraits : 'FamixCBTRuleComponent classTrait + FamixCBTRuleComposite classTrait',
	#instVars : [
		'#contextBlock => FMProperty'
	],
	#category : #'Famix-CriticBrowser-Entities-Entities'
}

{ #category : #meta }
FamixCBContext class >> annotation [

	<FMClass: #Context super: #FamixCBEntity>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
	^ self
]

{ #category : #'instance creation' }
FamixCBContext class >> named: aString on: anObject [
	^ self new
		name: aString;
		contextBlock: anObject;
		yourself
]

{ #category : #'instance creation' }
FamixCBContext class >> named: aString on: anObject summary: aSummary [
	^ self new
		name: aString;
		contextBlock: anObject;
		summary: aSummary;
		yourself
]

{ #category : #adding }
FamixCBContext >> addChild: aRuleComponent [

	aRuleComponent ruleContainer: self
]

{ #category : #adding }
FamixCBContext >> addEntity: anObject [
	<generated>
	^ self entities add: anObject
]

{ #category : #accessing }
FamixCBContext >> contextBlock [

	<FMProperty: #contextBlock type: #Object>
	<generated>
	<FMComment: 'Block to execute to get the context''s entities'>
	^ contextBlock
]

{ #category : #accessing }
FamixCBContext >> contextBlock: anObject [

	contextBlock := Smalltalk compiler evaluate: anObject
]

{ #category : #accessing }
FamixCBContext >> entities [
	"Relation named: #entities type: #MooseObject opposite: #contexts"

	<generated>
	<FMComment: 'Every entity that is a part of the context.'>
	<derived>
	<FMProperty: #entities type: #MooseObject opposite: #contexts>
	^ self attributeAt: #entities ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #contexts ]
]

{ #category : #accessing }
FamixCBContext >> entities: anObject [

	<generated>
	self entities value: anObject
]

{ #category : #'as yet unclassified' }
FamixCBContext >> putViolationsInto: aDictionary [
	self ruleComponents do: [ :child | child putViolationsInto: aDictionary ]

]

{ #category : #removing }
FamixCBContext >> removeChild: aRuleComponent [

	(self ruleComponents includes: aRuleComponent) ifFalse: [ ^ self ].
	self ruleComponents remove: aRuleComponent.
	aRuleComponent setParentToNilIfNeeded.
	aRuleComponent resetExecutionOfTree
]

{ #category : #removing }
FamixCBContext >> resetExecutionOfTree [

	self entities removeAll.
	self ruleComponents do: [ :child | child resetExecutionOfTree ]
]

{ #category : #running }
FamixCBContext >> runDownTree: aCollection withCallback: aBlock [

	self entities ifEmpty: [
		self runOn: aCollection withCallback: aBlock ].
	self ruleComponents do: [ :child |
		child runDownTree: self entities asMooseGroup withCallback: aBlock ]
]

{ #category : #running }
FamixCBContext >> runOn: aCollection [

	self entities: (contextBlock value: aCollection)

]

{ #category : #running }
FamixCBContext >> runOn: aCollection withCallback: aBlock [

	aBlock value: self name.
	self entities: (contextBlock value: aCollection)
]

{ #category : #'as yet unclassified' }
FamixCBContext >> runUpTree: aCollection [

	self entities ifEmpty: [ self runOn: (self ruleContainer runUpTree: aCollection) ].
	^ self entities
]

{ #category : #'ston persistence' }
FamixCBContext >> stonOn: stonWriter [
	stonWriter
		writeObject: self
		streamMap: [ :dictionary | 
			self class stonAllInstVarNames
				do: [ :each | 
					(self instVarNamed: each)
						ifNotNil: [ :value | 
							dictionary
								at: each asSymbol
								put:
									((value class = FullBlockClosure)
										ifTrue: [ value asString ]
										ifFalse: [ value ]) ] ] ] 
]

{ #category : #running }
FamixCBContext >> tagRuleResult [

	| model |

	model := self ruleComponents ifNotEmpty: [
		         (self ruleComponents first violations collect: #violatingEntity) first
			         mooseModel ].
	self ruleComponents do: [ :c | c tagRuleResultInModel: model ]
]
