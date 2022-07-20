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
	browser openTagGenerationForm.
]

{ #category : #tests }
MiTagGeneratorFormTest >> testStrategyChangesWhenButtonPress [
	self assert: presenter currentStrategy equals: CBOneTagGenerationStrategy.
	presenter setCBMultipleTagsForm.
	self assert: presenter currentStrategy equals: CBMultipleTagsGenerationStrategy.
	presenter setCBGraduatedTagsForm.
	self assert: presenter currentStrategy equals: CBGraduatedTagsGenerationStrategy.
	presenter setCBSingleTagForm.
	self assert: presenter currentStrategy equals: CBOneTagGenerationStrategy.
]
