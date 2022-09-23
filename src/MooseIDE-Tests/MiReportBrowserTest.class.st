Class {
	#name : #MiReportBrowserTest,
	#superclass : #MiAbstractBrowserTest,
	#category : #'MooseIDE-Tests-Browsers'
}

{ #category : #running }
MiReportBrowserTest >> browserClass [

	^ MiReportBrowser
]

{ #category : #tests }
MiReportBrowserTest >> testFollowEntity [

	| model entity |
	model := Mock named: 'mooseModel'.
	entity := Mock named: 'entity'.
	entity stub mooseModel willReturn: model.
	self assert: browser mooseModel isNil.

	browser followEntity: entity.

	self assert: browser mooseModel mockName equals: 'mooseModel'
]
