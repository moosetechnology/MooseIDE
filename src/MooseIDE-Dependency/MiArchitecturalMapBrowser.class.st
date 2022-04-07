"
I am a browser that display a hieracical map.
"
Class {
	#name : #MiArchitecturalMapBrowser,
	#superclass : #MiAbstractBrowser,
	#instVars : [
		'visualization',
		'layoutWithMenu',
		'layoutWithoutMenu',
		'settings',
		'tagCreateForm'
	],
	#category : #'MooseIDE-Dependency-ArchitecturalMap'
}

{ #category : #accessing }
MiArchitecturalMapBrowser class >> mapClass [

	^ MiArchitecturalMap
]

{ #category : #'world menu' }
MiArchitecturalMapBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>
	<miBrowsers>
	^(aBuilder item: #MiArchitecturalMapBrowser)
		parent: self midasBrowserMenuLabel;
		label: self title;
		help: self helpMessage;
		order: 5;
		action: [ self open ] ;
		yourself
]

{ #category : #'instance creation' }
MiArchitecturalMapBrowser class >> newModel [

	^ MiArchitecturalMapModel new
]

{ #category : #accessing }
MiArchitecturalMapBrowser class >> open [
	<script>
	super open
]

{ #category : #accessing }
MiArchitecturalMapBrowser class >> title [

	^ 'Architectural map'
]

{ #category : #accessing }
MiArchitecturalMapBrowser class >> windowSize [

	^ 850 @ 520
]

{ #category : #adding }
MiArchitecturalMapBrowser >> addDynamicTags: aCollection [

	aCollection do: [ :dt | self model addDynamicTag: dt ].
	settings refreshTagList
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> browserClosed [

	super browserClosed.
	application unregisterConsumer: self.
	application unregisterConsumer: settings
]

{ #category : #actions }
MiArchitecturalMapBrowser >> canFollowEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #testing }
MiArchitecturalMapBrowser >> canReceiveEntity: anEntity [

	^ anEntity isMooseObject
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> canvas [

	^ visualization canvas
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> closeTagCreationForm [

	self layout replace: tagCreateForm with: settings
]

{ #category : #brokerage }
MiArchitecturalMapBrowser >> consume: aTag [

	settings setTags
]

{ #category : #actions }
MiArchitecturalMapBrowser >> followEntity: anEntity [

	model entities: anEntity asMooseGroup.
	settings updateSettings.
]

{ #category : #testing }
MiArchitecturalMapBrowser >> hasSettings [

	^ true
]

{ #category : #actions }
MiArchitecturalMapBrowser >> hideMenu [

	self layout child: visualization
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> initialize [

	super initialize.
	application registerConsumer: self for: FamixTag.
	application registerConsumer: settings for: FQAbstractQuery
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> initializeLayout [

	self layout: (SpScrollableLayout with: visualization)
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> initializePresenters [

	visualization := self class mapClass owner: self.
	settings := MiArchitecturalMapSettings owner: self.
	settings setTags.
	tagCreateForm := MiDynamicTagSelectionForm owner: self.
	self initializeLayout.
	self showMenu
]

{ #category : #accessing }
MiArchitecturalMapBrowser >> miSelectedItem [

	^ model entities mooseInterestingEntity
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> openTagCreationForm [

	tagCreateForm setTags.
	self layout replace: settings with: tagCreateForm.
	self update
]

{ #category : #brokerage }
MiArchitecturalMapBrowser >> remove: aTag [

	tagCreateForm removeTag: aTag
]

{ #category : #accessing }
MiArchitecturalMapBrowser >> settings [

	self showMenu
]

{ #category : #accessing }
MiArchitecturalMapBrowser >> settingsPresenter [

	^ settings
]

{ #category : #actions }
MiArchitecturalMapBrowser >> showMenu [

	self layout child: settings
]

{ #category : #actions }
MiArchitecturalMapBrowser >> toggleMenu [

	(self layout presenters includes: settings)
		ifTrue: [ self hideMenu ]
		ifFalse: [ self showMenu ]
]

{ #category : #initialization }
MiArchitecturalMapBrowser >> visualization [

	^ visualization
]
