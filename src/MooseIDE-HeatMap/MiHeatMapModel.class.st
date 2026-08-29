Class {
	#name : 'MiHeatMapModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
		'childrenTypeName',
		'childrenRecursive',
		'startColor',
		'endColor',
		'colorBlock',
		'colorBlockSource'
	],
	#category : 'MooseIDE-HeatMap-Model',
	#package : 'MooseIDE-HeatMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiHeatMapModel class >> defaultColorBlockSource [

	^ '[ :entity | 1 ]'
]

{ #category : 'accessing' }
MiHeatMapModel class >> defaultEndColor [

	^ Color red
]

{ #category : 'accessing' }
MiHeatMapModel class >> defaultStartColor [

	^ Color white
]

{ #category : 'accessing' }
MiHeatMapModel >> availableChildrenTypes [

	^ self metamodelClasses
		  select: [ :c |
		  c implementingClass allTraits includes: FamixTSourceEntity ]
		  thenCollect: [ :c | c name ]
]

{ #category : 'accessing' }
MiHeatMapModel >> childrenFor: anEntity [

	| implementingClass pool |
	implementingClass := self childrenImplementingClass.
	implementingClass ifNil: [ ^ #(  ) ].
	pool := childrenRecursive
		        ifTrue: [ anEntity allContainedEntities ]
		        ifFalse: [ anEntity containedEntities ].
	^ pool select: [ :e | e isKindOf: implementingClass ]
]

{ #category : 'private' }
MiHeatMapModel >> childrenImplementingClass [

	| typeName |
	typeName := childrenTypeName ifNil: [ self defaultChildrenTypeName ].
	typeName ifNil: [ ^ nil ].
	^ (self metamodelClasses
		   detect: [ :c | c name = typeName ]
		   ifNone: [ nil ]) ifNotNil: [ :c | c implementingClass ]
]

{ #category : 'accessing' }
MiHeatMapModel >> childrenRecursive [

	^ childrenRecursive
]

{ #category : 'accessing' }
MiHeatMapModel >> childrenRecursive: anObject [

	childrenRecursive := anObject
]

{ #category : 'accessing' }
MiHeatMapModel >> childrenTypeName [

	^ childrenTypeName
]

{ #category : 'accessing' }
MiHeatMapModel >> childrenTypeName: anObject [

	childrenTypeName := anObject
]

{ #category : 'accessing' }
MiHeatMapModel >> colorBlock [

	^ colorBlock
]

{ #category : 'accessing' }
MiHeatMapModel >> colorBlockSource [

	^ colorBlockSource
]

{ #category : 'private' }
MiHeatMapModel >> compile: aString ifError: aBlock [

	^ [ Smalltalk compiler evaluate: aString ]
		  on: Error
		  do: [ :err | aBlock value ]
]

{ #category : 'settings management' }
MiHeatMapModel >> currentConfiguration [

	^ MiHeatMapSettingsConfiguration new
		  availableChildrenTypes: self availableChildrenTypes;
		  childrenTypeName:
			  (childrenTypeName ifNil: [ self defaultChildrenTypeName ]);
		  childrenRecursive: childrenRecursive;
		  startColor: startColor;
		  endColor: endColor;
		  colorBlockSource: colorBlockSource;
		  yourself
]

{ #category : 'accessing' }
MiHeatMapModel >> defaultChildrenTypeName [

	| available |
	available := self availableChildrenTypes.
	^ (available includes: 'Method')
		  ifTrue: [ 'Method' ]
		  ifFalse: [
		  available ifEmpty: [ nil ] ifNotEmpty: [ available first ] ]
]

{ #category : 'settings management' }
MiHeatMapModel >> defaultConfiguration [

	^ MiHeatMapSettingsConfiguration new
		  availableChildrenTypes: self availableChildrenTypes;
		  childrenTypeName: self defaultChildrenTypeName;
		  childrenRecursive: false;
		  startColor: self class defaultStartColor;
		  endColor: self class defaultEndColor;
		  colorBlockSource: self class defaultColorBlockSource;
		  yourself
]

{ #category : 'accessing' }
MiHeatMapModel >> endColor [

	^ endColor
]

{ #category : 'accessing' }
MiHeatMapModel >> entities [

	^ entities
]

{ #category : 'accessing' }
MiHeatMapModel >> entities: anObject [

	entities := anObject
]

{ #category : 'testing' }
MiHeatMapModel >> hasSettings [

	^ true
]

{ #category : 'initialization' }
MiHeatMapModel >> initializeSettings [

	childrenTypeName := self defaultChildrenTypeName.
	childrenRecursive := false.
	startColor := self class defaultStartColor.
	endColor := self class defaultEndColor.
	colorBlockSource := self class defaultColorBlockSource.
	colorBlock := self
		              compile: colorBlockSource
		              ifError: [ [ :entity | 1 ] ]
]

{ #category : 'accessing' }
MiHeatMapModel >> metamodelClasses [

	self entities isEmptyOrNil ifTrue: [ ^ #(  ) ].
	^ [ self entities anyOne class metamodel classes ]
		  on: Error
		  do: [ :e | #(  ) ]
]

{ #category : 'settings management' }
MiHeatMapModel >> settingsPresenterExtent [

	^ 450 @ 350
]

{ #category : 'accessing' }
MiHeatMapModel >> startColor [

	^ startColor
]

{ #category : 'settings management' }
MiHeatMapModel >> updateColorBlockFrom: aString [
	"Compile once, only on Settings-OK. Never let a syntax/runtime error during
	 compilation crash the settings dialog or destroy the previously working block."

	| newBlock |
	newBlock := self compile: aString ifError: [ nil ].
	((newBlock isKindOf: BlockClosure) and: [ newBlock numArgs = 1 ])
		ifTrue: [
				colorBlock := newBlock.
				colorBlockSource := aString ]
		ifFalse: [
				UIManager default inform:
					'Heat map: the color block is invalid (must be a 1-argument block, e.g. [ :entity | entity numberOfMethods ]).
The previous, working block was kept.' ]
]

{ #category : 'settings management' }
MiHeatMapModel >> updateFromConfiguration: aConfiguration [

	childrenTypeName := aConfiguration childrenTypeName.
	childrenRecursive := aConfiguration childrenRecursive.
	startColor := aConfiguration startColor.
	endColor := aConfiguration endColor.
	self updateColorBlockFrom: aConfiguration colorBlockSource.

	browser runVisualization
]
