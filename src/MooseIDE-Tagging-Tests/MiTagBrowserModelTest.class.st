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
		'method',
		'browser',
		'application',
		'bus'
	],
	#category : #'MooseIDE-Tagging-Tests'
}

{ #category : #running }
MiTagBrowserModelTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"

	application := MiTestApplication new.
	bus := application defaultBus.
	application defaultBus: bus.
	browser := MiTagBrowser openForTests: application.
	model := browser model.

	selectedClass1 := FamixJavaClass new numberOfMethods: 3.
	selectedClass2 := FamixJavaClass new numberOfMethods: 12.
	notSelectedClass := FamixJavaClass new numberOfMethods: 42.
	method := FamixJavaMethod new
]

{ #category : #running }
MiTagBrowserModelTest >> tearDown [

	browser window ifNotNil: [ :window | window close ].
	application deleteBus: bus.
	super tearDown
]

{ #category : #test }
MiTagBrowserModelTest >> testAddTagsFromTagBuilder [

	| dictsForTags mooseModel |
	mooseModel := FamixJavaModel new.
	mooseModel
		add: selectedClass1;
		add: selectedClass2;
		add: notSelectedClass;
		add: method.

	model entities: mooseModel.


	dictsForTags := { 
		                (Dictionary newFrom: { 
				                 ('name' -> 'numberOfMethods <= 5').
				                 ('color' -> (Color fromString: '7BCCC4')).
				                 ('type' -> FamixJavaClass).
				                 ('query'
				                  -> [ :entity | entity numberOfMethods <= 5 ]) }).
		                (Dictionary newFrom: { 
				                 ('name' -> 'numberOfMethods <= 15').
				                 ('color' -> (Color fromString: '4EB3D3')).
				                 ('type' -> FamixJavaClass).
				                 ('query'
				                  -> [ :entity | entity numberOfMethods <= 15 ]) }) }.

	self
		shouldnt: (model addTagsFromTagBuilder: dictsForTags)
		raise: MessageNotUnderstood.

	self
		assertCollection:
		(model getTagNamed: 'numberOfMethods <= 5') taggedEntities
		hasSameElements: { selectedClass1 }.
	self
		assertCollection:
		(model getTagNamed: 'numberOfMethods <= 15') taggedEntities
		hasSameElements: { 
				selectedClass1.
				selectedClass2 }
]
