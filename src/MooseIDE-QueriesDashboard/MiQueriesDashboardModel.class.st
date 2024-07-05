Class {
	#name : #MiQueriesDashboardModel,
	#superclass : #Object,
	#instVars : [
		'queries',
		'mooseModel'
	],
	#category : #'MooseIDE-QueriesDashboard-Browser'
}

{ #category : #accessing }
MiQueriesDashboardModel >> mooseModel [

	^ mooseModel
]

{ #category : #accessing }
MiQueriesDashboardModel >> mooseModel: anObject [

	mooseModel := anObject
]
