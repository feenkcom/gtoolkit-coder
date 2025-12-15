Class {
	#name : #GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement,
	#superclass : #GtTextualCoderViewModelAnnouncement,
	#instVars : [
		'consumed',
		'text',
		'visibleText'
	],
	#category : 'GToolkit-Coder-UI-Coder - Source Events'
}

{ #category : #accessing }
GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement >> consumed [
	^ consumed ifNil: [ false ]
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement >> consumed: aBoolean [
	consumed := aBoolean
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement >> text [
	^ text
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement >> text: anObject [
	text := anObject
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement >> visibleText [
	^ visibleText
]

{ #category : #accessing }
GtTextualCoderViewModelSearchTextGetTextAndVisibleTextAnnouncement >> visibleText: anObject [
	visibleText := anObject
]
