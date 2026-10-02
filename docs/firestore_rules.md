# Reglas de Firestore

Copia esto en **Firebase Console → Firestore Database → Reglas** y publica.

Incluye la colección nueva `liveGames/{code}`, que es la que permite que alguien
que **no** es miembro del grupo siga una partida con solo el código.

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    function isSignedIn() {
      return request.auth != null;
    }

    // ---------- Perfiles ----------
    match /profiles/{uid} {
      allow read: if isSignedIn();
      allow write: if isSignedIn() && request.auth.uid == uid;
    }

    // ---------- Grupos ----------
    function isMember(groupId) {
      return isSignedIn() &&
        request.auth.uid in
          get(/databases/$(database)/documents/groups/$(groupId)).data.memberIds;
    }

    match /groups/{groupId} {
      allow read: if isMember(groupId);
      allow create: if isSignedIn();
      allow update, delete: if isMember(groupId);

      match /members/{uid} {
        allow read: if isMember(groupId);
        allow write: if isMember(groupId);
      }

      match /games/{gameId} {
        allow read, write: if isMember(groupId);
      }

      match /teams/{teamId} {
        allow read, write: if isMember(groupId);
      }

      match /rounds/{roundId} {
        allow read, write: if isMember(groupId);
      }
    }

    // ---------- Partidas en vivo ----------
    // Cualquier usuario autenticado que tenga el código puede leerla.
    // Solo quien la publicó puede crear/actualizar/borrar el documento.
    match /liveGames/{code} {
      allow read: if isSignedIn();
      allow create: if isSignedIn() &&
        request.resource.data.hostId == request.auth.uid;
      allow update, delete: if isSignedIn() &&
        resource.data.hostId == request.auth.uid;
    }
  }
}
```

## Notas

- Los invitados necesitan **tener sesión iniciada** (cualquier cuenta sirve) y
  el **código** de la partida. No hace falta ser miembro del grupo.
- Las reglas de `groups/**` exigen pertenecer al grupo, así que un invitado no
  puede ver el grupo completo: solo la partida publicada en `liveGames`.
- Firestore por REST no tiene tiempo real; la pantalla de "Partida en vivo" se
  refresca sola cada 5 segundos.
