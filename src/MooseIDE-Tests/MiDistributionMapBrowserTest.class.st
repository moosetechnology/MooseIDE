Class {
	#name : 'MiDistributionMapBrowserTest',
	#superclass : 'MiAbstractBrowserTest',
	#category : 'MooseIDE-Tests-Browsers',
	#package : 'MooseIDE-Tests',
	#tag : 'Browsers'
}

{ #category : 'running' }
MiDistributionMapBrowserTest >> browserClass [

	^ MiDistributionMapBrowser
]

{ #category : 'running' }
MiDistributionMapBrowserTest >> receiveEntityToSelect [

	browser receiveEntity: entityToSelect asMooseGroup
]

{ #category : 'tests - tags' }
MiDistributionMapBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]

{ #category : 'tests' }
MiDistributionMapBrowserTest >> testSettingsAction [

	self assert: browser hasSettings
]

{ #category : 'tests' }
MiDistributionMapBrowserTest >> testSettingsClickOK [
	"overriding to setup the right context"

	browser specModel entities: #(  ).
	self
		shouldnt: [
				browser openSettings.
				browser specModel settings buttonOk click ]
		raise: Error
]
