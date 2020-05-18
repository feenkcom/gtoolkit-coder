Class {
	#name : #RBRemovePackageTagChange,
	#superclass : #RBPackageChange,
	#instVars : [
		'tagName'
	],
	#category : #'GToolkit-Coder-Refactorings'
}

{ #category : #'instance creation' }
RBRemovePackageTagChange class >> packageName: aString tagName: tagName [
	^ (self packageName: aString)
		tagName: tagName;
		yourself
]

{ #category : #converting }
RBRemovePackageTagChange >> asUndoOperation [
	^ RBAddPackageTagChange packageName: packageName tagName: tagName
]

{ #category : #private }
RBRemovePackageTagChange >> primitiveExecute [
	self package removeClassTag: tagName
]

{ #category : #accessing }
RBRemovePackageTagChange >> tagName [
	^ tagName
]

{ #category : #accessing }
RBRemovePackageTagChange >> tagName: aString [
	tagName := aString asSymbol
]
