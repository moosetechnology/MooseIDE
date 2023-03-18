Class {
	#name : #MiButterflyMapBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiButterflyMapBrowserTest >> browserClass [

	^ MiButterflyMapBrowser
]

{ #category : #tests }
MiButterflyMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #'tests - tags' }
MiButterflyMapBrowserTest >> testTagSelectedSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser tagSelected: tag.
	self assert: browser tagSelected equals: tag
]
