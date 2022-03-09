"
Shows UML of the received entities.

- Follow: Receives a TypeGroup or entities using TType.
- Highlight: Entities if present
- Propagate: The selected entity if there is one
"
Class {
	#name : #MiUMLBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'diagram'
	],
	#category : #'MooseIDE-Famix-UML'
}

{ #category : #layout }
MiUMLBrowser class >> defaultLayout [
	^ super defaultLayout
		add: #diagram;
		yourself
]

{ #category : #'world menu' }
MiUMLBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #UMLVisualisationBrowser)
		parent: (self toolbarFamixName);
		label: (self title);
		icon: (self iconNamed: #mooseUml);
		order: 4;
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiUMLBrowser class >> newModel [

	^ MiUMLModel new
]

{ #category : #'instance creation' }
MiUMLBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiUMLBrowser class >> title [
	^ 'UML'
]

{ #category : #testing }
MiUMLBrowser >> canFollowEntity: anObject [

	^ anObject isMooseObject and: [ 
		  anObject asMooseSpecializedGroup isKindOf: FamixTypeGroup ]
]

{ #category : #testing }
MiUMLBrowser >> canHighlight [

	^ true
]

{ #category : #actions }
MiUMLBrowser >> followEntity: anEntity [

	model
		entities: anEntity asMooseSpecializedGroup;
		unselectAll.
	diagram
		rootEntities: model entities;
		run
]

{ #category : #actions }
MiUMLBrowser >> highlightEntity: anEntity [

	diagram highlightEntities: anEntity asCollection
]

{ #category : #initialization }
MiUMLBrowser >> initializePresenters [

	diagram := self instantiate: MiUML
]

{ #category : #accessing }
MiUMLBrowser >> miSelectedItem [

	^ (model selected ifNil: [ model entities ]) mooseInterestingEntity
]

{ #category : #accessing }
MiUMLBrowser >> selected: anEntity [

	model selected: anEntity
]
