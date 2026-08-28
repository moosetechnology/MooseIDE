Class {
	#name : 'MiHeatMapModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'entities',
		'childrenQuery',
		'startColor',
		'endColor',
		'colorBlock',
		'colorBlockSource'
	],
	#category : 'MooseIDE-HeatMap-Tests',
	#package : 'MooseIDE-HeatMap',
	#tag : 'Tests'
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
MiHeatMapModel >> childrenFor: anEntity [

	^ childrenQuery runOn: anEntity asMooseGroup
]

{ #category : 'accessing' }
MiHeatMapModel >> childrenQuery [

	^ childrenQuery
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
		  childrenQuery: childrenQuery;
		  startColor: startColor;
		  endColor: endColor;
		  colorBlockSource: colorBlockSource;
		  yourself
]

{ #category : 'settings management' }
MiHeatMapModel >> defaultConfiguration [

	^ MiHeatMapSettingsConfiguration new
		  childrenQuery: self defaultChildrenQuery;
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

	childrenQuery := self defaultChildrenQuery.
	startColor := self class defaultStartColor.
	endColor := self class defaultEndColor.
	colorBlockSource := self class defaultColorBlockSource.
	colorBlock := self
		              compile: colorBlockSource
		              ifError: [ [ :entity | 1 ] ]
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

	childrenQuery := aConfiguration childrenQuery.
	startColor := aConfiguration startColor.
	endColor := aConfiguration endColor.
	self updateColorBlockFrom: aConfiguration colorBlockSource.

	browser runVisualization
]
