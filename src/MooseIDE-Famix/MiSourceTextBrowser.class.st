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

{ #category : #'world menu' }
MiSourceTextBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	<miBrowsersMenu>
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
MiSourceTextBrowser class >> preferredExtent [

	^ 600 @ 700
]

{ #category : #specs }
MiSourceTextBrowser class >> title [

	^ 'Source code'
]

{ #category : #testing }
MiSourceTextBrowser >> canFollowEntity: anObject [

	^ anObject usesFamixTrait: FamixTSourceEntity
]

{ #category : #layout }
MiSourceTextBrowser >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: toolBarExternalEditor height: self class toolbarHeight;
		  add: textRenderer expand: true;
		  yourself
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

	super followEntity: anEntity.
	specModel displayedEntity: anEntity.

	toolBarExternalEditor newEntity
]

{ #category : #settings }
MiSourceTextBrowser >> hasSettings [

	^ true
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

{ #category : #initialization }
MiSourceTextBrowser >> open [
	"redefined to change the cursor in the text morph"
	super open.

	textRenderer adapter widget theme: MiSourceTextRendererTheme new.

]

{ #category : #formatting }
MiSourceTextBrowser >> reRenderText [ 

	textRenderer reRenderText
]

{ #category : #formatting }
MiSourceTextBrowser >> renderTextFor: anEntity [

	textRenderer renderTextFor: anEntity
]

{ #category : #settings }
MiSourceTextBrowser >> settingsModel [

	^ specModel settings
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

{ #category : #formatting }
MiSourceTextBrowser >> withRoassalRenderer [

	self deprecated: 'RoassalRenderer is out of sync with the rest of the code'.

	textRenderer := self instantiate: MiSourceTextRoassalRenderer on: specModel
]

{ #category : #formatting }
MiSourceTextBrowser >> withSpecRenderer [

	textRenderer := self instantiate: MiSourceTextSpecRenderer on: specModel
]
