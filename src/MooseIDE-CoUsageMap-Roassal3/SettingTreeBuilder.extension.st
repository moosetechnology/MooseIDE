Extension { #name : #SettingTreeBuilder }

{ #category : #'*MooseIDE-CoUsageMap-Roassal3' }
SettingTreeBuilder >> miRange: aSymbol [
	^ self nodeClass: MiCoRangeSettingDeclaration name: aSymbol
]
