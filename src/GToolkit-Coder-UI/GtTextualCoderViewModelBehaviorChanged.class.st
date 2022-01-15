Class {
	#name : #GtTextualCoderViewModelBehaviorChanged,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'newBehavior'
	],
	#category : #'GToolkit-Coder-UI-Coder - Textual Model - Events'
}

{ #category : #accessing }
GtTextualCoderViewModelBehaviorChanged >> newBehavior: aBehavior [
	newBehavior := aBehavior
]
