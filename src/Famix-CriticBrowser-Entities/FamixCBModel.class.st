Class {
	#name : #FamixCBModel,
	#superclass : #MooseModel,
	#traits : 'FamixCBTEntityCreator + MooseTEntityCreator',
	#classTraits : 'FamixCBTEntityCreator classTrait + MooseTEntityCreator classTrait',
	#category : #'Famix-CriticBrowser-Entities-Model'
}

{ #category : #accessing }
FamixCBModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'Moose-Core' #'Famix-Traits')
]

{ #category : #meta }
FamixCBModel class >> annotation [
	<FMClass: #FamixCBModel super: #MooseModel>
	<package: #'Famix-CriticBrowser-Entities'>
	<generated>
]
