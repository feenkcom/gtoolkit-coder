Class {
	#name : #RBAddPackageTagChange,
	#superclass : #RBAddPackageChange,
	#instVars : [
		'tagName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBAddPackageTagChange class >> packageName: aString tagName: tagName [
	^ (self packageName: aString)
		tagName: tagName;
		yourself
]

{ #category : #converting }
RBAddPackageTagChange >> asUndoOperation [
	^ self package isNil
		ifTrue: [ RBRemovePackageChange packageName: packageName ]
		ifFalse: [ RBRemovePackageTagChange packageName: packageName tagName: tagName ]
]

{ #category : #private }
RBAddPackageTagChange >> primitiveExecute [
	self package isNil
		ifTrue: [ super primitiveExecute ].
	self package addClassTag: tagName
]

{ #category : #accessing }
RBAddPackageTagChange >> tag [
	^ self package
		ifNotNil: [ :pkg | pkg classTagNamed: tagName ifAbsent: [  ] ]
]

{ #category : #accessing }
RBAddPackageTagChange >> tagName [
	^ tagName
]

{ #category : #accessing }
RBAddPackageTagChange >> tagName: aString [
	tagName := aString asSymbol
]
