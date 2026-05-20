import sqlite3
import json
from pathlib import Path

DB_FILE = Path(__file__).resolve().parent / 'database.sqlite'
DB_FILE.parent.mkdir(parents=True, exist_ok=True)

print(f"Database file path: {DB_FILE.resolve()}")

connection = sqlite3.connect(DB_FILE)
connection.execute('PRAGMA foreign_keys = ON;')
cursor = connection.cursor()

create_table_sql = [
    '''
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL CHECK(role IN ('patient', 'counsellor', 'admin')) DEFAULT 'patient',
        phone TEXT,
        dateOfBirth TEXT,
        profilePicture TEXT,
        sobrietyStartDate TEXT,
        emergencyContact TEXT,
        preferences TEXT,
        isActive INTEGER NOT NULL DEFAULT 1,
        lastLogin TEXT,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''',
    '''
    CREATE TABLE IF NOT EXISTS counsellors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        licenseNumber TEXT NOT NULL UNIQUE,
        institution TEXT NOT NULL,
        specialty TEXT NOT NULL,
        experience INTEGER NOT NULL DEFAULT 0,
        qualifications TEXT,
        certifications TEXT,
        bio TEXT,
        rating REAL NOT NULL DEFAULT 0,
        reviewCount INTEGER NOT NULL DEFAULT 0,
        availability TEXT,
        languages TEXT,
        isVerified INTEGER NOT NULL DEFAULT 0,
        verificationDocuments TEXT,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE
    );
    ''',
    '''
    CREATE TABLE IF NOT EXISTS appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patientId INTEGER NOT NULL,
        counsellorId INTEGER NOT NULL,
        type TEXT NOT NULL CHECK(type IN ('counselling', 'follow-up', 'group-session')),
        date TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        method TEXT NOT NULL CHECK(method IN ('in-person', 'video', 'phone')),
        status TEXT NOT NULL CHECK(status IN ('scheduled', 'confirmed', 'completed', 'cancelled', 'no-show')) DEFAULT 'scheduled',
        notes TEXT,
        location TEXT,
        meetingLink TEXT,
        reminderSent INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(patientId) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY(counsellorId) REFERENCES counsellors(id) ON DELETE CASCADE
    );
    ''',
    '''
    CREATE TABLE IF NOT EXISTS resources (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL CHECK(category IN ('article', 'video', 'audio', 'tool', 'guide')),
        tags TEXT,
        authorId INTEGER,
        isPublished INTEGER NOT NULL DEFAULT 0,
        publishedAt TEXT,
        viewCount INTEGER NOT NULL DEFAULT 0,
        likeCount INTEGER NOT NULL DEFAULT 0,
        mediaUrl TEXT,
        thumbnailUrl TEXT,
        readingTime INTEGER,
        language TEXT NOT NULL CHECK(language IN ('en', 'si', 'ta')) DEFAULT 'en',
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(authorId) REFERENCES users(id) ON DELETE SET NULL
    );
    ''',
    '''
    CREATE TABLE IF NOT EXISTS chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        participants TEXT NOT NULL,
        lastMessage TEXT,
        isActive INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
    );
    ''',
    '''
    CREATE TABLE IF NOT EXISTS messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chatId INTEGER NOT NULL,
        senderId INTEGER NOT NULL,
        content TEXT NOT NULL,
        messageType TEXT NOT NULL CHECK(messageType IN ('text', 'image', 'file')) DEFAULT 'text',
        isRead INTEGER NOT NULL DEFAULT 0,
        timestamp TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(chatId) REFERENCES chats(id) ON DELETE CASCADE,
        FOREIGN KEY(senderId) REFERENCES users(id) ON DELETE CASCADE
    );
    ''',
]

for sql in create_table_sql:
    cursor.executescript(sql)

sample_users = [
    {
        'fullName': 'Alice Johnson',
        'email': 'alice@example.com',
        'password': 'password123',
        'role': 'patient',
        'phone': '+1234567890',
        'dateOfBirth': '1990-04-12',
        'profilePicture': None,
        'sobrietyStartDate': None,
        'emergencyContact': json.dumps({'name': 'John Doe', 'phone': '+1987654321'}),
        'preferences': json.dumps({'language': 'en', 'notifications': True, 'theme': 'light'}),
        'isActive': 1,
        'lastLogin': None
    },
    {
        'fullName': 'Dr. Luna Wells',
        'email': 'luna@example.com',
        'password': 'securepass',
        'role': 'counsellor',
        'phone': '+1098765432',
        'dateOfBirth': '1984-09-22',
        'profilePicture': None,
        'sobrietyStartDate': None,
        'emergencyContact': json.dumps({'name': 'Emergency Contact', 'phone': '+1122334455'}),
        'preferences': json.dumps({'language': 'en', 'notifications': True, 'theme': 'dark'}),
        'isActive': 1,
        'lastLogin': None
    }
]

insert_user_sql = '''
INSERT OR IGNORE INTO users (
    fullName, email, password, role, phone, dateOfBirth,
    profilePicture, sobrietyStartDate, emergencyContact, preferences,
    isActive, lastLogin, createdAt, updatedAt
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
'''

for user in sample_users:
    cursor.execute(insert_user_sql, [
        user['fullName'],
        user['email'],
        user['password'],
        user['role'],
        user['phone'],
        user['dateOfBirth'],
        user['profilePicture'],
        user['sobrietyStartDate'],
        user['emergencyContact'],
        user['preferences'],
        user['isActive'],
        user['lastLogin']
    ])

cursor.execute('SELECT id FROM users WHERE email = ?', ('luna@example.com',))
result = cursor.fetchone()
if result:
    counsellor_user_id = result[0]
else:
    raise ValueError('Counsellor user not inserted correctly.')

cursor.execute('SELECT id FROM users WHERE email = ?', ('alice@example.com',))
result = cursor.fetchone()
if result:
    patient_user_id = result[0]
else:
    raise ValueError('Patient user not inserted correctly.')

cursor.execute('''
INSERT OR IGNORE INTO counsellors (
    userId, licenseNumber, institution, specialty, experience,
    qualifications, certifications, bio, rating, reviewCount,
    availability, languages, isVerified, verificationDocuments,
    createdAt, updatedAt
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
''', (
    counsellor_user_id,
    'LIC-2026-1234',
    'MindPath Institute',
    'Mental Health Counseling',
    7,
    json.dumps(['MSc Psychology', 'PhD Clinical Practice']),
    json.dumps(['CBT', 'Mindfulness']),
    'Experienced counsellor specializing in anxiety, depression, and life transition support.',
    4.9,
    120,
    json.dumps({'monday': '10:00-16:00', 'wednesday': '12:00-18:00'}),
    json.dumps(['en', 'si', 'ta']),
    1,
    json.dumps({'documents': ['license.pdf', 'certification.pdf']})
))

cursor.execute('SELECT id FROM counsellors WHERE licenseNumber = ?', ('LIC-2026-1234',))
result = cursor.fetchone()
if result:
    counsellor_id = result[0]
else:
    raise ValueError('Counsellor record not inserted correctly.')

cursor.execute('''
INSERT OR IGNORE INTO appointments (
    patientId, counsellorId, type, date, startTime, endTime,
    method, status, notes, location, meetingLink, reminderSent,
    createdAt, updatedAt
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
''', (
    patient_user_id,
    counsellor_id,
    'counselling',
    '2026-05-29',
    '14:00',
    '15:00',
    'video',
    'scheduled',
    'Initial intake session.',
    'Online',
    'https://meet.example.com/mindpath-1',
    0
))

cursor.execute('''
INSERT OR IGNORE INTO resources (
    title, content, category, tags, authorId, isPublished,
    publishedAt, viewCount, likeCount, mediaUrl, thumbnailUrl,
    readingTime, language, createdAt, updatedAt
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
''', (
    'Managing Anxiety During Transitions',
    'A guide to managing anxiety with mindfulness, journaling, and routine adjustments.',
    'article',
    json.dumps(['anxiety', 'transition', 'mindfulness']),
    counsellor_user_id,
    1,
    '2026-05-20T12:00:00',
    250,
    35,
    None,
    None,
    8,
    'en'
))

cursor.execute('''
INSERT OR IGNORE INTO chats (
    participants, lastMessage, isActive, createdAt, updatedAt
) VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
''', (
    json.dumps([patient_user_id, counsellor_id]),
    json.dumps({'senderId': counsellor_user_id, 'content': 'Hello, I look forward to our session.'}),
    1
))

cursor.execute('SELECT id FROM chats ORDER BY id DESC LIMIT 1')
result = cursor.fetchone()
if result:
    chat_id = result[0]
else:
    raise ValueError('Chat record not inserted correctly.')

cursor.execute('''
INSERT OR IGNORE INTO messages (
    chatId, senderId, content, messageType, isRead, timestamp,
    createdAt, updatedAt
) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
''', (
    chat_id,
    counsellor_user_id,
    'Hello Alice, I look forward to our appointment next week.',
    'text',
    0
))

index_statements = [
    'CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);',
    'CREATE INDEX IF NOT EXISTS idx_counsellors_userId ON counsellors(userId);',
    'CREATE INDEX IF NOT EXISTS idx_counsellors_licenseNumber ON counsellors(licenseNumber);',
    'CREATE INDEX IF NOT EXISTS idx_appointments_patientId ON appointments(patientId);',
    'CREATE INDEX IF NOT EXISTS idx_appointments_counsellorId ON appointments(counsellorId);',
    'CREATE INDEX IF NOT EXISTS idx_resources_authorId ON resources(authorId);',
    'CREATE INDEX IF NOT EXISTS idx_chats_isActive ON chats(isActive);',
    'CREATE INDEX IF NOT EXISTS idx_messages_chatId ON messages(chatId);',
    'CREATE INDEX IF NOT EXISTS idx_messages_senderId ON messages(senderId);'
]

for sql in index_statements:
    cursor.execute(sql)

connection.commit()
print('Sample data inserted and indexes created successfully.')

cursor.execute('SELECT COUNT(*) FROM users')
print('Users count:', cursor.fetchone()[0])
cursor.execute('SELECT COUNT(*) FROM counsellors')
print('Counsellors count:', cursor.fetchone()[0])
cursor.execute('SELECT COUNT(*) FROM appointments')
print('Appointments count:', cursor.fetchone()[0])
cursor.execute('SELECT COUNT(*) FROM resources')
print('Resources count:', cursor.fetchone()[0])
cursor.execute('SELECT COUNT(*) FROM chats')
print('Chats count:', cursor.fetchone()[0])
cursor.execute('SELECT COUNT(*) FROM messages')
print('Messages count:', cursor.fetchone()[0])

connection.close()
print('Database creation complete.')