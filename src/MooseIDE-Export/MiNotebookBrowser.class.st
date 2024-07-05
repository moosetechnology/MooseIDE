"
I am a moose notebook browser.
Accepted entities: any moose entity that knows its moose model.

There are two kind of cells:
 - Microdown cells.
 - Code cells.

You can switch a microdown cell to a code cell by clicking to its label (left). Same for the other way.

In microdown cells, you can write raw microdown.

In code cells you can script and write on a stream.
Code cells share an excution context, you can define variables in a code block and use it in following code cells.
Some globals are avalaible in all code cells:
 - mooseModel. The moose model you can query and acess.
 - stream. The stream you can write on.
 - printer. A printer with utility methods to print on the stream, see MiAbstractReportPrinter class.

When the notebook is executed, all cells are responsible to print there content in the stream. The order of cells is therfore important.
"
Class {
	#name : #MiNotebookBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'notebook'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #layout }
MiNotebookBrowser class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: #notebook;
		  yourself
]

{ #category : #'world menu' }
MiNotebookBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsers>
	(aBuilder item: #Reporter)
		parent: #Moose;
		label: self title;
		icon: (self iconNamed: #smallExport);
		order: 6;
		help: self helpMessage;
		action: [ self open ]
]

{ #category : #'world menu' }
MiNotebookBrowser class >> menuItem [

	^ #reporteBuilder
]

{ #category : #'instance creation' }
MiNotebookBrowser class >> newModel [

	^ MiNotebookModel new
]

{ #category : #'instance creation' }
MiNotebookBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiNotebookBrowser class >> title [

	^ 'Notebook'
]

{ #category : #specs }
MiNotebookBrowser class >> windowSize [

	^ 1083 @ 697
]

{ #category : #testing }
MiNotebookBrowser >> canFollowEntity: anObject [

	^ true
]

{ #category : #actions }
MiNotebookBrowser >> followEntity: anEntity [

	specModel mooseModel: anEntity mooseModel.
	notebook addBinding: 'mooseModel' -> anEntity mooseModel
]

{ #category : #initialization }
MiNotebookBrowser >> initializePresenters [

	notebook := self instantiate: INNotebookPresenter.
	notebook addBinding: 'mooseModel' -> nil
]

{ #category : #accessing }
MiNotebookBrowser >> miSelectedItem [

	^ specModel entities
]
