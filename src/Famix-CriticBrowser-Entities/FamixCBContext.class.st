Class {
	#name : #FamixCBContext,
	#superclass : #FamixCBEntity,
	#traits : 'FamixCBTRuleComponent',
	#classTraits : 'FamixCBTRuleComponent classTrait',
	#instVars : [
		'#children => FMMany type: #FamixCBTRuleComponent opposite: #parent',
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
	aRuleComponent parent: self
]

{ #category : #adding }
FamixCBContext >> addChildren: anObject [
	<generated>
	^ self children add: anObject
]

{ #category : #adding }
FamixCBContext >> addEntity: anObject [
	<generated>
	^ self entities add: anObject
]

{ #category : #accessing }
FamixCBContext >> children [
	"Relation named: #children type: #FamixCBTRuleComponent opposite: #parent"

	<generated>
	<FMComment: 'Every child context or condition of this context.'>
	<derived>
	^ children
]

{ #category : #accessing }
FamixCBContext >> children: anObject [

	<generated>
	children value: anObject
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
	children do: [ :child | child putViolationsInto: aDictionary ]

]

{ #category : #removing }
FamixCBContext >> removeChild: aRuleComponent [

	(children includes: aRuleComponent) ifFalse: [ ^ self ].
	children remove: aRuleComponent.
	aRuleComponent setParentToNilIfNeeded.
	aRuleComponent resetExecutionOfTree
]

{ #category : #removing }
FamixCBContext >> resetExecutionOfTree [
	self entities removeAll.
	children do: [ :child | child resetExecutionOfTree ]

]

{ #category : #running }
FamixCBContext >> runDownTree: aCollection [

	self entities ifEmpty: [ self runOn: aCollection ].
	children do: [ :child | child runDownTree: self entities asMooseGroup ]
]

{ #category : #running }
FamixCBContext >> runOn: aCollection [

	self entities: (contextBlock value: aCollection)

]

{ #category : #'as yet unclassified' }
FamixCBContext >> runUpTree: aCollection [

	self entities ifEmpty: [ self runOn: (parent runUpTree: aCollection) ].
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
