Class {
	#name : #MiArchitecturalMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#instVars : [
		'entity1',
		'entity2',
		'entity3'
	],
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiArchitecturalMapBrowserTest >> browserClass [

	^ MiArchitecturalMapBrowser
]

{ #category : #running }
MiArchitecturalMapBrowserTest >> setUp [
	| model |
	super setUp.
	
	model := FamixStModel new.
	entity1 := FamixStClass new name: 'class1' ; mooseModel: model ; yourself.
	entity2 := FamixStClass new name: 'class2' ; mooseModel: model ; yourself.
	entity3 := FamixStClass new name: 'class3' ; mooseModel: model ; yourself.

]

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testMiSelectedItemWithSelection [
	"returns selected entities"
	| map |
	map := browser visualization.
	
	browser followEntity: { entity1 . entity2 . entity3 }.
	map canvas selectedShapes: { map shapeFromEntity: entity1 . map shapeFromEntity: entity3 }.
	
	self assertCollection: browser miSelectedItem hasSameElements:   { entity1 . entity3 }.
	
]

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testMiSelectedItemWithoutSelection [
	"returns all entities"
	| map |
	map := browser visualization.
	
	browser followEntity: { entity1 . entity2 . entity3 }.
	
	self assertCollection: browser miSelectedItem hasSameElements:   { entity1 . entity2 . entity3 }.
	
]

{ #category : #'tests - tags' }
MiArchitecturalMapBrowserTest >> testSelectedTagSetAndGet [
	| tag |
	tag := entity1 mooseModel tagNamed: 'aTag'.
	browser followEntity: { entity1 . entity2 . entity3 }.
	browser selectedTag: tag.

	self assert: browser selectedTag equals: tag
]

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #tests }
MiArchitecturalMapBrowserTest >> testSettingsClickOK [
	"overriding to setup the right context"

	browser model entities: #().
	self
		shouldnt: [ 
			browser settings.
			browser model settings buttonOk click ]
		raise: Error.

]
