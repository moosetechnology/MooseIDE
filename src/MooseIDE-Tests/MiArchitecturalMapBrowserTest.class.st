Class {
	#name : 'MiArchitecturalMapBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#instVars : [
		'entity1',
		'entity2',
		'entity3'
	],
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiArchitecturalMapBrowserTest >> browserClass [

	^ MiArchitecturalMapBrowser
]

{ #category : 'running' }
MiArchitecturalMapBrowserTest >> setUp [
	| model |
	super setUp.
	
	model := FamixStModel new.
	entity1 := FamixStClass new name: 'class1' ; mooseModel: model ; yourself.
	entity2 := FamixStClass new name: 'class2' ; mooseModel: model ; yourself.
	entity3 := FamixStClass new name: 'class3' ; mooseModel: model ; yourself.

]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testMiSelectedItemWithSelection [
	"returns selected entities"
	| map |
	map := browser visualization.
	
	browser followEntity: { entity1 . entity2 . entity3 }.
	map canvas selectedShapes: { map shapeFromEntity: entity1 . map shapeFromEntity: entity3 }.
	
	self assertCollection: browser miSelectedItem hasSameElements:   { entity1 . entity3 }.
	
]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testMiSelectedItemWithoutSelection [
	"returns all entities"
	| map |
	map := browser visualization.
	
	browser followEntity: { entity1 . entity2 . entity3 }.
	
	self assertCollection: browser miSelectedItem hasSameElements:   { entity1 . entity2 . entity3 }.
	
]

{ #category : 'tests - tags' }
MiArchitecturalMapBrowserTest >> testSelectedTagSetAndGet [
	| tag |
	tag := entity1 mooseModel tagNamed: 'aTag'.
	browser followEntity: { entity1 . entity2 . entity3 }.
	browser selectedTag: tag.

	self assert: browser selectedTag equals: tag
]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testSettingsAvailableLayouts [

	self assert: browser specModel class availableLayouts isNotEmpty
]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testSettingsCanBeSavedAsSTON [
	"The Save button of the settings writes the configuration with STON.
	It must only contain plain settings (no live browser, no blocks)."

	| configuration |
	configuration := browser specModel currentConfiguration.
	self shouldnt: [ STON toString: configuration ] raise: Error
]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testSettingsDefaultLayout [

	self assert: browser specModel layout equals: RSFlowLayout
]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testSettingsKeepNoneChoiceAfterSaveAndLoad [
	"Choosing None for dependencies and tags must still be None after Save and Load,
	even when the map has no dependency types or tags to choose from"

	| configuration loaded |
	configuration := browser specModel currentConfiguration.
	configuration
		associationTypesMode: #none;
		associationTypes: OrderedCollection new;
		tagsMode: #none;
		tags: OrderedCollection new.

	loaded := STON fromString: (STON toString: configuration).

	self assert: loaded associationTypesMode equals: #none.
	self assert: loaded tagsMode equals: #none.
	self assert:
		((MiAssociationTypesSettingPresenter on: loaded) instVarNamed: #noItemsButton) state.
	self assert:
		((MiTagsSettingPresenter on: loaded) instVarNamed: #noItemsButton) state
]

{ #category : 'tests' }
MiArchitecturalMapBrowserTest >> testShowLoadingMessage [

	| labels |
	browser visualization showLoadingMessage.
	labels := browser canvas shapes select: [ :shape | shape isKindOf: RSLabel ].
	self assert: labels size equals: 1.
	self assert: labels first text equals: 'Building visualization...'
]
