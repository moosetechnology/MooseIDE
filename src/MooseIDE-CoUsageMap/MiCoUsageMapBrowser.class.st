"
This browser shows dependencies between ""container entities"" (e.g. methods) and ""used entities"" (e.g. attributes) and it allows to mark entities with tags.
Use settings to configure it.
In order to navigate across the visualization.

Accepted entities: a MooseGroup.

Controls:

* Mouse over to highlight common inner boxes
* Mouse click to keep the highlight
* right click over a box, to use the menu
* right click over the view to use the general menu
* command+click to use the last tag.

* Mouse left to drag
* Arrrow keys to move the visualization around
* Scrolls bars to change the view's position
* M to collapse or expand the window
* I to zoom in
* O to zoom out
* Moouse Wheel to zoom in/out
* S to search entities by their name (several search can be applied)
* R to clear all searches
"
Class {
	#name : #MiCoUsageMapBrowser,
	#superclass : #MiAbstractVisualizationBrowser,
	#category : #'MooseIDE-CoUsageMap-Browser'
}

{ #category : #'world menu' }
MiCoUsageMapBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self buildMenuItemIn: aBuilder
]

{ #category : #'world menu' }
MiCoUsageMapBrowser class >> menuItem [

	^ #FilesBrowser
]

{ #category : #'world menu' }
MiCoUsageMapBrowser class >> menuPriority [

	^ self menuVisualizationToolsPriority + 3
]

{ #category : #'instance creation' }
MiCoUsageMapBrowser class >> newModel [
	^MiCoUsageMapModel new
]

{ #category : #'instance creation' }
MiCoUsageMapBrowser class >> open [

	<script>
	^ super open
]

{ #category : #specs }
MiCoUsageMapBrowser class >> title [

	^ 'Co Usage Map'
]

{ #category : #specs }
MiCoUsageMapBrowser class >> windowSize [

	^ 900 @ 700
]

{ #category : #'window control' }
MiCoUsageMapBrowser >> browserClosed [
	super browserClosed.
	application unregisterConsumer: mainPresenter.
	application unregisterProducer: mainPresenter.
	"settings mapVisualization: nil.
	mapVisualization settings: nil."

]

{ #category : #testing }
MiCoUsageMapBrowser >> canFollowEntity: anEntity [
	^ anEntity isCollection and: [ anEntity isMooseModel not ]
]

{ #category : #'private - for tests' }
MiCoUsageMapBrowser >> closeSettings [
	"to close the settings window when testing
	Should not be used otherwise"

	specModel closeSettings 
]

{ #category : #initialization }
MiCoUsageMapBrowser >> connectPresenters [
	"settings mapVisualization: mapVisualization.
	mapVisualization settings: settings."
]

{ #category : #actions }
MiCoUsageMapBrowser >> followEntity: anEntity [
	self model followEntity: anEntity
]

{ #category : #testing }
MiCoUsageMapBrowser >> hasSettings [ 
	^ true
]

{ #category : #initialization }
MiCoUsageMapBrowser >> initializePresenters [
	mainPresenter := self instantiate: MiCoUsageMapVisualization.
	mainPresenter specModel: specModel.

	"self flag: 'this should be in MiCoUsageMapModel'.
	settings := self instantiate: MiCoUsageMapInstanceSettingsPresenter."
	
	self flag: 'this should be in MiCoUsageMapVisualization'.
	application registerConsumer: mainPresenter for: FamixTag.
	application registerConsumer: mainPresenter for: FamixTagAssociation.
	application registerProducer: mainPresenter for: FamixTagAssociation.
]

{ #category : #accessing }
MiCoUsageMapBrowser >> mapVisualization [
	^ mainPresenter
]

{ #category : #dependencies }
MiCoUsageMapBrowser >> release [
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #actions }
MiCoUsageMapBrowser >> settings [ 
	specModel openSettings
]

{ #category : #updating }
MiCoUsageMapBrowser >> update [
	self deprecated: 'Use runVisualization method instead' transformWith: '`@receiver update' -> '`@receiver runVisualization'.
	self runVisualization 
]

{ #category : #public }
MiCoUsageMapBrowser >> updateBoxColor: aMiCoBox fromTags: tags [

	mainPresenter updateBoxColor: aMiCoBox fromTags: tags
]
