Class {
	#name : #MiDMBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDMBrowserTest >> browserClass [

	^ MiDMBrowser
]

{ #category : #'tests - tags' }
MiDMBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : #tests }
MiDMBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : #tests }
MiDMBrowserTest >> testSettingsClickOK [
	"overriding to setup the right context"

	browser model entities: #().
	self
		shouldnt: [ 
			browser settings.
			browser model settings buttonOk click ]
		raise: Error.

]
