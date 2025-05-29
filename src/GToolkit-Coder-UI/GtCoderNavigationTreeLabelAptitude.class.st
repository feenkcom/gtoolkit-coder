Class {
	#name : #GtCoderNavigationTreeLabelAptitude,
	#superclass : #BrGlamorousLabelAptitude,
	#category : #'GToolkit-Coder-UI-Looks'
}

{ #category : #initialization }
GtCoderNavigationTreeLabelAptitude >> initialize [
	super initialize.

	self foreground: self theme label navigationTextForeground
]
