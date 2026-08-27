Class {
	#name : 'MiHeatMapBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiHeatMapBrowserTest >> browserClass [

	^ MiHeatMapBrowser
]

{ #category : 'running' }
MiHeatMapBrowserTest >> receiveEntityToSelect [

	browser receiveEntity: entityToSelect asMooseGroup
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testDefaultBlockGivesUniformColor [
	"constant-value default block -> every leaf entity gets the same color."

	| model class1 |
	model := FamixStModel new.
	class1 := model newClassNamed: 'A'.
	(model newMethodNamed: 'm1') parentType: class1.
	(model newMethodNamed: 'm2') parentType: class1.

	browser followEntity: model entities.
	browser runVisualization.

	self assert:
		((browser visualization builder rootNode children flatCollect: [ :c |
			  c children ]) collect: #color) asSet size <= 1
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

	| model class1 lowMethod highMethod config leafNodes low high |
	model := FamixStModel new.
	class1 := model newClassNamed: 'A'.
	lowMethod := (model newMethodNamed: 'lo') parentType: class1.
	highMethod := (model newMethodNamed: 'higherName') parentType: class1.

	browser followEntity: model entities.

	config := browser specModel currentConfiguration.
	config
		colorBlockSource: '[ :entity | entity name size ]';
		startColor: Color blue;
		endColor: Color yellow.
	browser specModel updateFromConfiguration: config.

	leafNodes := browser visualization builder rootNode children
		             flatCollect: [ :c | c children ].
	low := leafNodes detect: [ :n | n rawModel = lowMethod ].
	high := leafNodes detect: [ :n | n rawModel = highMethod ].

	self assert: low color equals: Color blue.
	self assert: high color equals: Color yellow
]

{ #category : 'tests' }
MiHeatMapBrowserTest >> testInvalidBlockTextDoesNotCrashOrDestroyPreviousBlock [

	| oldBlock oldSource |
	browser followEntity: FamixStModel new entities.
	oldBlock := browser specModel colorBlock.
	oldSource := browser specModel colorBlockSource.

	browser specModel updateColorBlockFrom: '[ :e | '.

	self assert: browser specModel colorBlock == oldBlock.
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
