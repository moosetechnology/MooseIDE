"
Shows the source text of an entity if it has one.

- Follow: Receives a MooseEntity that uses FamixTSourceEntity.
- Highlight: Nothing to do.
- Propagate: <TODO>

<TODO> Improvement: tabs for several entities (receiving a MooseGroup)
"
Class {
	#name : #MiSourceTextBrowser,
	#superclass : #MiAbstractFamixBrowser,
	#instVars : [
		'toolBarExternalEditor',
		'textRenderer'
	],
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #layout }
MiSourceTextBrowser class >> defaultLayout [

	^ super defaultLayout
		  add: #toolBarExternalEditor height: self toolbarHeight;
		  add: #sourceText expand: true;
		  yourself
]

{ #category : #'world menu' }
MiSourceTextBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	(aBuilder item: #SourceTextBrowser)
		parent: (self toolbarFamixName) ;
		label: (self title) ;
		icon: (self iconNamed: #mooseSourceText);
		order: 1 ;
		help: (self helpMessage);
		action: [ self open ]
]

{ #category : #'instance creation' }
MiSourceTextBrowser class >> newModel [

	^ MiSourceTextBrowserModel new
]

{ #category : #'instance creation' }
MiSourceTextBrowser class >> open [
	<script>
	^ super open
]

{ #category : #specs }
MiSourceTextBrowser class >> title [
	^ 'Source code'
]

{ #category : #specs }
MiSourceTextBrowser class >> windowSize [
	^ 600 @ 700
]

{ #category : #testing }
MiSourceTextBrowser >> canFollowEntity: anObject [

	^ anObject usesFamixTrait: FamixTSourceEntity
]

{ #category : #actions }
MiSourceTextBrowser >> editExternally: anExternalTool [
	anExternalTool new open: model selectedEntity
]

{ #category : #'private - testing' }
MiSourceTextBrowser >> externalEditor [
	"only for testing"
	^toolBarExternalEditor externalEditor 
]

{ #category : #'private - testing' }
MiSourceTextBrowser >> externalEditor: anObject [
	"only for testing"
	toolBarExternalEditor externalEditor: anObject
]

{ #category : #actions }
MiSourceTextBrowser >> followEntity: anEntity [

	model displayedEntity: anEntity.
	textRenderer renderText.

	self updateWindowTitleWith: anEntity name.

	toolBarExternalEditor newEntity.
]

{ #category : #initialization }
MiSourceTextBrowser >> initializePresenters [

	toolBarExternalEditor := self instantiate: MiSourceTextToolBar on: self.
	"self withRoassalRenderer."
	self withSpecRenderer.
]

{ #category : #accessing }
MiSourceTextBrowser >> miSelectedItem [

	^ model selectedEntity
]

{ #category : #initialization }
MiSourceTextBrowser >> setModelBeforeInitialization: aModel [
	super setModelBeforeInitialization: aModel.
	aModel browser: self
]

{ #category : #'private - testing' }
MiSourceTextBrowser >> textRenderer [
	^textRenderer
]

{ #category : #'private - testing' }
MiSourceTextBrowser >> toolBarExternalEditor [
	"only for testing"
	^toolBarExternalEditor
]

{ #category : #'private - testing' }
MiSourceTextBrowser >> toolBarExternalEditor: anObject [
	"only for testing"
	toolBarExternalEditor := anObject
]

{ #category : #actions }
MiSourceTextBrowser >> updateWindowTitleWith: aName [

	self withWindowDo: [ :window | 
		window title: self class title , ' of ' , aName ]
]

{ #category : #formatting }
MiSourceTextBrowser >> withRoassalRenderer [

	textRenderer := self instantiate: MiSourceTextRoassalRenderer on: model
]

{ #category : #formatting }
MiSourceTextBrowser >> withSpecRenderer [

	textRenderer := self instantiate: MiSourceTextSpecRenderer on: model
]
