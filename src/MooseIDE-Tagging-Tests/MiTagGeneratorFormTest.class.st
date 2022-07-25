"
A MiTagGeneratorFormTest is a test class for testing the behavior of MiTagGeneratorForm
"
Class {
	#name : #MiTagGeneratorFormTest,
	#superclass : #MiTagPresenterTest,
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #helpers }
MiTagGeneratorFormTest >> presenterClass [

	^ MiTagGeneratorForm
]

{ #category : #helpers }
MiTagGeneratorFormTest >> presenterOwner [

	^ browser
]

{ #category : #running }
MiTagGeneratorFormTest >> setUp [

	super setUp.
	browser openTagGenerationFormFor: {  }.
]

{ #category : #test }
MiTagGeneratorFormTest >> testSetSourceItems [
	| condition condition2 |
	condition := FamixCBCondition named: 'test' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isDead ]').
	condition2 := FamixCBCondition named: 'test2' on: (MiCriticBrowserPharoCodeQuery on: '[ :entity | entity isStub ]').
	presenter setSourceItems: { condition. condition2 }.
	self assertCollection: presenter itemChooser sourceList items hasSameElements: { condition. condition2 }
]

{ #category : #tests }
MiTagGeneratorFormTest >> testputAllButtonsStateToFalseExcept [
	self assert: presenter currentStrategy equals: OneTagGenerationStrategy.
	presenter setCBMultipleTagsForm.
	self assert: presenter currentStrategy equals: MultipleTagsGenerationStrategy.
	presenter setCBGradualTagsForm.
	self assert: presenter currentStrategy equals: GradualTagsGenerationStrategy.
	presenter setCBSingleTagForm.
	self assert: presenter currentStrategy equals: OneTagGenerationStrategy.
]
