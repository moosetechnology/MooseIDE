"
Shows the source text of an entity if it has one.

- Accepted entities: a MooseEntity that uses FamixTSourceEntity.
- Highlight: Nothing to do.
- Propagate: <TODO>

<TODO> Improvement: tabs for several entities (receiving a MooseGroup)
"
Class {
	#name : #MiSourceTextBrowser,
	#superclass : #MiAbstractBrowser,
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
		  add: #textRenderer expand: true;
		  yourself
]

{ #category : #'world menu' }
MiSourceTextBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiSourceTextBrowser class >> menuIconName [

	^ #mooseSourceText
]

{ #category : #'world menu' }
MiSourceTextBrowser class >> menuItem [

	^ #SourceTextBrowser
]

{ #category : #'world menu' }
MiSourceTextBrowser class >> menuPriority [

	^ self menuCodeToolsPriority + 1
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
	anExternalTool new open: specModel selectedEntity
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

	specModel displayedEntity: anEntity.
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

	^ specModel selectedEntity
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

	textRenderer := self instantiate: MiSourceTextRoassalRenderer on: specModel
]

{ #category : #formatting }
MiSourceTextBrowser >> withSpecRenderer [

	textRenderer := self instantiate: MiSourceTextSpecRenderer on: specModel
]
