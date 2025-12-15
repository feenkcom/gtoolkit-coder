Class {
	#name : #GtCoderUIConstants,
	#superclass : #Object,
	#category : 'GToolkit-Coder-UI-Utilities'
}

{ #category : #initialization }
GtCoderUIConstants class >> actionsToolbarHeight [
	"Coder toobar items are computed later and the coder element height adopted accordingly. 
	In case of list of coders, it does not behave a best way,
	because the list layout:
	- first, computes position (ehgith) of coders without the toolbar action items, 
	- second, scrolls to a specific coder item,
	- third, recomputes the coders height.
	As a consequence, the position of the item users 
	wanted to scroll to, might be significantly shifted.
	As a workaround, we explicitly set (a minimum) toolbar height."

	^ 16
]
