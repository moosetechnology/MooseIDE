"
A MiTagBrowserModelTest is a test class for testing the behavior of MiTagBrowserModel
"
Class {
	#name : #MiTagBrowserModelTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'selectedClass1',
		'selectedClass2',
		'notSelectedClass',
		'method'
	],
	#category : #'MooseIDE-Tagging-Tests-Browser'
}

{ #category : #running }
MiTagBrowserModelTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	
	model := MiTagBrowserModel new.
	
	selectedClass1 := FamixJavaClass new numberOfMethods: 3.
	selectedClass2 := FamixJavaClass new numberOfMethods: 12.
	notSelectedClass := FamixJavaClass new numberOfMethods: 42.
	method := FamixJavaMethod new. 
]

{ #category : #test }
MiTagBrowserModelTest >> testAddTagsFromTagBuilder [

	| dictsForTags |
	model entities: { 
			selectedClass1.
			selectedClass2.
			notSelectedClass.
			method } asMooseGroup.

	dictsForTags := { 
		                (Dictionary newFrom: { 
				                 ('name' -> 'numberOfMethods <= 5').
				                 ('color' -> Color fromString: '7BCCC4').
				                 ('query'
				                  -> [ :entity | entity cyclomaticComplexity <= 5 ]) }).
		                (Dictionary newFrom: { 
				                 ('name' -> 'numberOfMethods <= 15').
				                 ('color' -> Color fromString: '4EB3D3').
				                 ('query'
				                  -> [ :entity | 
				                  entity cyclomaticComplexity <= 15 ]) }) }.

	self
		shouldnt: (model addTagsFromTagBuilder: dictsForTags)
		raise: MessageNotUnderstood
	
	
]
