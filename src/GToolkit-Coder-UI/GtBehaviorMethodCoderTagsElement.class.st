Class {
	#name : #GtBehaviorMethodCoderTagsElement,
	#superclass : #GtMethodCoderTagsElement,
	#instVars : [
		'classTag'
	],
	#category : #'GToolkit-Coder-UI-Coder - Method'
}

{ #category : #initialization }
GtBehaviorMethodCoderTagsElement >> buildTags [
	^ super buildTags, { classTag := self newClassTag }
]

{ #category : #private }
GtBehaviorMethodCoderTagsElement >> classTagStringFor: aMethodCoder [
	<return: #String>

	^ aMethodCoder classOrMetaClass isMeta
		ifTrue: [ 'class' ]
		ifFalse: [ 'instance' ]
]

{ #category : #accessing }
GtBehaviorMethodCoderTagsElement >> coder: aMethodCoder [
	super coder: aMethodCoder.

	classTag text: (self classTagStringFor: aMethodCoder)
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newClassTag [
	^ isEditable
		ifTrue: [ self newEditableClassTag ]
		ifFalse: [ self newReadonlyClassTag ]
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newEditableClassTag [
	| editor completion strategy |

	editor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				glamorousCodeFont;
				defaultForeground: Color black;
				fontSize: 10);
		padding: (BlInsets all: 2);
		margin: (BlInsets all: 0).
		
	editor
		when: BrEditorModeWish
			do: [ :wish | 				
			(wish mode isEditable
				and: [ self coder canMoveMethodToInstanceOrClass not ])
				ifTrue: [ editor beReadOnlyWithoutSelection.
					wish mode: BrTextEditorReadonlyWithoutSelectionMode new ] ];
		when: BrEditorAcceptWish
			do: [ :wish | 
			(self coder classOrMetaClass isMeta
				ifTrue: [ wish text asString asLowercase = 'instance' ]
				ifFalse: [ wish text asString asLowercase = 'class' ])
				ifTrue: [ self coder moveMethodToInstanceOrClass ].
			editor text: (self classTagStringFor: self coder).
			wish consumed: true ];
		whenKey: BlKeyCombination primaryC
			labelDo: [ :anEvent :aShortcut :aTextEditor :aCoderTagsElement | 
				Clipboard clipboardText: aTextEditor text asString ]
			with: self.
	
	strategy := GtStringsCompletionStrategy new.
	(GtCompletionController on: editor strategy: strategy) install.
	completion := GtPrefixTree withAll: #('instance' 'class').
	strategy completions: completion.
	^ editor
]

{ #category : #'instance creation' }
GtBehaviorMethodCoderTagsElement >> newReadonlyClassTag [
	<return: #BlElement>

	^ self newTag
]
