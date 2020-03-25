Class {
	#name : #GtClassCoderHeaderRenameInstVarWish,
	#superclass : #GtClassCoderHeaderWish,
	#instVars : [
		'oldName',
		'newName'
	],
	#category : #'GToolkit-Coder-Class - Events'
}

{ #category : #accessing }
GtClassCoderHeaderRenameInstVarWish >> newName [
	^ newName
]

{ #category : #accessing }
GtClassCoderHeaderRenameInstVarWish >> newName: anObject [
	newName := anObject
]

{ #category : #accessing }
GtClassCoderHeaderRenameInstVarWish >> oldName [
	^ oldName
]

{ #category : #accessing }
GtClassCoderHeaderRenameInstVarWish >> oldName: anObject [
	oldName := anObject
]
