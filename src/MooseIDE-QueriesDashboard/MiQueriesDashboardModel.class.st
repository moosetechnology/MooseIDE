Class {
	#name : 'MiQueriesDashboardModel',
	#superclass : 'MiAbstractModel',
	#instVars : [
		'queries',
		'mooseModel'
	],
	#category : 'MooseIDE-QueriesDashboard-Browser',
	#package : 'MooseIDE-QueriesDashboard',
	#tag : 'Browser'
}

{ #category : 'accessing' }
MiQueriesDashboardModel >> mooseModel [

	^ mooseModel
]

{ #category : 'accessing' }
MiQueriesDashboardModel >> mooseModel: anObject [

	mooseModel := anObject
]
