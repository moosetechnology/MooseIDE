Class {
	#name : #MiButterflyMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiButterflyMapBrowserTest >> browserClass [

	^ MiButterflyMapBrowser
]

{ #category : #'tests - tags' }
MiButterflyMapBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : #tests }
MiButterflyMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]
