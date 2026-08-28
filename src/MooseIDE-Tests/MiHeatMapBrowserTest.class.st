Class {
	#name : 'MiHeatMapBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-Tests',
	#package : 'MooseIDE-Tests'
}

{ #category : 'running' }
MiHeatMapBrowserTest >> browserClass [

	^ MiHeatMapBrowser
]

{ #category : 'running' }
MiHeatMapBrowserTest >> innerNodes [

	^self outerNodes flatCollect: #children
]

{ #category : 'running' }
MiHeatMapBrowserTest >> outerNodes [

	^browser visualization builder rootNode children
]

{ #category : 'running' }
MiHeatMapBrowserTest >> receiveEntityToSelect [

	browser receiveEntity: entityToSelect asMooseGroup
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testDefaultBlockGivesUniformColor [
	"constant-value default block -> every leaf entity gets the same color."

	| clazz |
	clazz := FamixStClass new.
	FamixStMethod new parentType: clazz.
	FamixStMethod new parentType: clazz.

	browser followEntity: clazz.

	self
		assert: (self innerNodes collectAsSet: #color) size
		equals: 1
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testDefaultColorsAreWhiteToRed [

	self assert: browser specModel startColor equals: Color white.
	self assert: browser specModel endColor equals: Color red
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testGradientCorrectnessAtMinAndMax [
	"custom block distinguishing two methods: the min-value method's node color
	 should equal startColor, and the max-value method's node color endColor."

	| clazz lowMethod highMethod config low high |
	clazz := FamixStClass new.
	lowMethod := FamixStMethod new name: 'short' ; parentType: clazz ; yourself.
	highMethod := FamixStMethod new name: 'longName' ; parentType: clazz ; yourself.

	config := browser specModel currentConfiguration.
	config colorBlockSource: '[ :entity | entity name size ]'.
	browser specModel updateFromConfiguration: config.

	browser followEntity: clazz.

	low := self innerNodes detect: [ :n | n rawModel = lowMethod ].
	high := self innerNodes detect: [ :n | n rawModel = highMethod ].

	self assert: low color equals: Color white.
	self assert: high color equals: Color red
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testInvalidBlockTextDoesNotCrashOrDestroyPreviousBlock [

	| oldBlock oldSource |
	browser followEntity: FamixStModel new entities.
	oldBlock := browser specModel colorBlock.
	oldSource := browser specModel colorBlockSource.

	browser specModel updateColorBlockFrom: '[ :e | '.

	self assert: browser specModel colorBlock equals: oldBlock.
	self assert: browser specModel colorBlockSource equals: oldSource
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testSettingsRoundTrip [

	| config |
	browser followEntity: FamixStModel new entities.

	config := browser specModel currentConfiguration.
	config
		colorBlockSource: '[ :entity | 3 ]';
		startColor: Color green;
		endColor: Color black.
	browser specModel updateFromConfiguration: config.

	self assert: browser specModel startColor equals: Color green.
	self assert: browser specModel endColor equals: Color black.
	self
		assert: browser specModel colorBlockSource
		equals: '[ :entity | 3 ]'.
	self assert: (browser specModel colorBlock value: nil) equals: 3
]
