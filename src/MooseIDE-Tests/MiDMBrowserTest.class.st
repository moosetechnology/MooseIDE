Class {
	#name : #MiDMBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiDMBrowserTest >> browserClass [

	^ MiDMBrowser
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

{ #category : #'tests - tags' }
MiDMBrowserTest >> testTagSelectedSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser tagSelected: tag.
	self assert: browser tagSelected equals: tag
]
