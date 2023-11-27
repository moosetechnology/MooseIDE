Class {
	#name : #MiNotebookBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiNotebookBrowserTest >> browserClass [

	^ MiNotebookBrowser
]

{ #category : #tests }
MiNotebookBrowserTest >> testFollowEntity [

	| model entity |
	model := Mock named: 'mooseModel'.
	entity := Mock named: 'entity'.
	entity stub mooseModel willReturn: model.
	self assert: browser mooseModel isNil.

	browser followEntity: entity.

	self assert: browser mooseModel mockName equals: 'mooseModel'
]

{ #category : #'tests - tags' }
MiNotebookBrowserTest >> testSelectedTagSetAndGet [
	| model entity tag |
	model := FamixRepTestModel new.
	tag := model tagNamed: 'aTag'.
	entity := FamixRepTestClass new name: 'aClass' ; mooseModel: model ; yourself.

	browser followEntity: entity.
	browser selectedTag: tag.
	self assert: browser selectedTag equals: tag
]
