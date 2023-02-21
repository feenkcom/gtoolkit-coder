Class {
	#name : #GtNavigationDropDownCreateWish,
	#superclass : #BrWish,
	#instVars : [
		'tabName'
	],
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #accessing }
GtNavigationDropDownCreateWish class >> showTab: aCreationForm [
	^self new tabName: aCreationForm componentName
]

{ #category : #accessing }
GtNavigationDropDownCreateWish >> tabName [
	^ tabName
]

{ #category : #accessing }
GtNavigationDropDownCreateWish >> tabName: aString [
	tabName := aString 
]
